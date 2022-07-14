//
//  Keychain.swift
//  Strike
//
//  Created by Ata Namvari on 2022-03-01.
//

import Foundation
import Security
import LocalAuthentication
import CryptoKit
import BIP39

public class Keychain {
    private class func queryDictionary(account: String, service: String) -> [String : Any] {
        return [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : account,
            kSecAttrService as String : service
        ]
    }

    @discardableResult
    public class func save(account: String, service: String, data: Data, synced: Bool = false, biometryProtected: Bool = false) -> Bool {
        var query = queryDictionary(account: account, service: service)
        query[kSecValueData as String] = data

        if synced {
            query[kSecAttrSynchronizable as String] = true
        }

        SecItemDelete(query as CFDictionary)

        if biometryProtected {
            query[kSecAttrAccessControl as String] = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, [.userPresence], nil)
        }

        let result = SecItemAdd(query as CFDictionary, nil)
        return result == noErr
    }

    public class func load(account: String, service: String, synced: Bool = false, biometryPrompt: String? = nil) -> Data? {
        var query = queryDictionary(account: account, service: service)
        query[kSecReturnData as String] = kCFBooleanTrue!
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecAttrSynchronizable as String] = synced

        if let prompt = biometryPrompt {
            let context = LAContext()
            context.localizedReason = prompt

            query[kSecUseAuthenticationContext as String] = context
            query[kSecAttrAccessControl as String] = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, [.userPresence], nil)
        }

        var foundData: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &foundData)

        if status == noErr {
            return foundData as! Data?
        }
        else {
            return nil
        }
    }

    @discardableResult
    public class func clear(account: String, service: String, synced: Bool = false) -> Bool {
        var query = queryDictionary(account: account, service: service)

        if synced {
            query[kSecAttrSynchronizable as String] = true
        }

        let result = SecItemDelete(query as CFDictionary)
        return result == noErr
    }
}

extension Keychain {
    enum KeyError: Error {
        case couldNotDecode
        case couldNotSavePrivateKey
        case noPrivateKey
    }

    static private let privateKeyService = "com.strikeprotocols.private-key"
    static private let rootSeedService = "com.strikeprotocols.root-seed"

    struct KeyPair {
        let encryptedPrivateKey: String
        let publicKey: String
    }

    static func publicKey(email: String) -> String? {
        // RETIRE THIS BLOCK AND REMOVE PRODUCTION FLAG
        #if !PRODUCTION
        let passphraseService = "com.strikeprotocols.private-pass"

        if load(account: email, service: passphraseService, synced: true) != nil {
            clear(account: email, service: passphraseService, synced: true)
            clear(account: email, service: privateKeyService)
        }
        #endif

        guard let privateKey = privateKey(for: email) else {
            return nil
        }

        let publicKeyData = privateKey.publicKey.rawRepresentation
        return Base58.encode(publicKeyData.bytes)
    }

    static func savePrivateKey(_ privateKey: Curve25519.Signing.PrivateKey, rootSeed: [UInt8], email: String) throws {
        if !save(account: email, service: rootSeedService, data: Data(rootSeed)) {
            throw KeyError.couldNotSavePrivateKey
        }

        if !save(account: email, service: privateKeyService, data: privateKey.rawRepresentation) {
            throw KeyError.couldNotSavePrivateKey
        }
    }

    static func privateKey(for account: String) -> Curve25519.Signing.PrivateKey? {
        if let privateKeyData = load(account: account, service: privateKeyService) {
            return try? Curve25519.Signing.PrivateKey(rawRepresentation: privateKeyData)
        } else if let rootSeedData = load(account: account, service: rootSeedService) {
            return try? Ed25519HierachicalPrivateKey.fromRootSeed(rootSeed: rootSeedData.bytes).privateKey
        } else {
            return nil
        }
    }
}

extension Keychain {
    static func signature(for signable: SolanaSignable, email: String) throws -> String {
        let keyInfo = try keyInfoForEmail(email: email)
        let signData = try signable.signableData(approverPublicKey: keyInfo.encodedPublicKey)
        let signature = try keyInfo.privateKey.signature(for: signData)

        return signature.base64EncodedString()
    }
    
    static func signatureForKey(for signable: SolanaSignable, email: String, ephemeralPrivateKey: Curve25519.Signing.PrivateKey) throws -> String {
        let keyInfo = try keyInfoForEmail(email: email)
        let signData = try signable.signableData(approverPublicKey: keyInfo.encodedPublicKey)
        let signature = try ephemeralPrivateKey.signature(for: signData)

        return signature.base64EncodedString()
    }
    
    private static func keyInfoForEmail(email: String) throws -> (privateKey: Curve25519.Signing.PrivateKey, encodedPublicKey: String) {
        guard let privateKeyData = load(account: email, service: privateKeyService) else {
            throw KeyError.noPrivateKey
        }

        let privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: privateKeyData)
        let publicKeyData = privateKey.publicKey.rawRepresentation
        let encodedPublicKey = Base58.encode(publicKeyData.bytes)
        return (privateKey, encodedPublicKey)
    }
}
