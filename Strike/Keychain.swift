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
    public class func clear(account: String, service: String) -> Bool {
        let query = queryDictionary(account: account, service: service)
        let result = SecItemDelete(query as CFDictionary)
        return result == noErr
    }
}

extension Keychain {
    enum KeyError: Error {
        case couldNotGeneratePassphrase
        case couldNotSavePassphrase
        case couldNotFindPassphrase
        case couldNotDecode
        case couldNotSavePrivateKey
        case noPrivateKey
    }

    static private let passphraseService = "com.strikeprotocols.private-pass"
    static private let privateKeyService = "com.strikeprotocols.private-key"

    struct KeyPair {
        let encryptedPrivateKey: String
        let publicKey: String
    }

    static func publicKey(email: String) -> String? {
        guard let privateKeyData = load(account: email, service: privateKeyService) else {
            return nil
        }

        guard let privateKey = try? Curve25519.Signing.PrivateKey(rawRepresentation: privateKeyData) else {
            return nil
        }

        let publicKeyData = privateKey.publicKey.rawRepresentation
        return Base58.encode(publicKeyData.bytes)
    }

    static func keyPair(email: String) throws -> KeyPair {
        if let passphrase = load(account: email, service: passphraseService, synced: true),
           let privateKeyData = load(account: email, service: privateKeyService) {
            let privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: privateKeyData)
            let sealedData = try AES.GCM.seal(privateKey.rawRepresentation, using: .init(data: passphrase), nonce: nil)

            return KeyPair(
                encryptedPrivateKey: Base58.encode(sealedData.combined!.bytes),
                publicKey: Base58.encode(privateKey.publicKey.rawRepresentation.bytes)
            )
        }

        var bytes = [Int8](repeating: 0, count: 32)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)

        if status != errSecSuccess {
            throw KeyError.couldNotGeneratePassphrase
        }

        let passphrase = bytes.withUnsafeBufferPointer(Data.init(buffer:))

        guard save(account: email, service: passphraseService, data: passphrase, synced: true) else {
            throw KeyError.couldNotSavePassphrase
        }

        let privateKey = Curve25519.Signing.PrivateKey()

        let sealedData = try AES.GCM.seal(privateKey.rawRepresentation, using: .init(data: passphrase), nonce: nil)

        return KeyPair(
            encryptedPrivateKey: Base58.encode(sealedData.combined!.bytes),
            publicKey: Base58.encode(privateKey.publicKey.rawRepresentation.bytes)
        )
    }

    static func savePrivateKey(_ encryptedKey: String, email: String) throws {
        guard let passphrase = load(account: email, service: passphraseService, synced: true) else {
            throw KeyError.couldNotFindPassphrase
        }

        let data = Base58.decode(encryptedKey)
        let combinedData = data.withUnsafeBufferPointer(Data.init(buffer:))
        let sealedBox = try AES.GCM.SealedBox(combined: combinedData)
        let decryptedData = try AES.GCM.open(sealedBox, using: .init(data: passphrase))

        if !save(account: email, service: privateKeyService, data: decryptedData) {
            throw KeyError.couldNotSavePrivateKey
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
