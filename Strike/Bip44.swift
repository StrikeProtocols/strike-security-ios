//
//  Bip44.swift
//  Strike
//
//  Created by Brendan Flood on 6/9/22.
//

import Foundation
import CryptoKit
import BIP39

struct Ed25519HierachicalPrivateKey {
    public let privateKey: Curve25519.Signing.PrivateKey
    public let chainCode: SymmetricKey
    
    public init(privateKey: Curve25519.Signing.PrivateKey, chainCode: SymmetricKey) throws {
        self.privateKey = privateKey
        self.chainCode = chainCode
    }
    
    public init(data: Data) throws {
        self.privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: data.prefix(32))
        self.chainCode = SymmetricKey(data: data.suffix(32))
    }
    
    public static func fromSeedPhrase(words: [String]) throws -> Ed25519HierachicalPrivateKey {
        var derivedKey = try Ed25519HierachicalPrivateKey(
            data: try Data(HMAC<SHA512>.authenticationCode(
                for: Mnemonic(phrase: words).seed,
                using: SymmetricKey.init(data: "ed25519 seed".data(using: .utf8)!)
            ))
        )

        // BIP-44 path with the Solana coin-type
        // https://github.com/satoshilabs/slips/blob/master/slip-0044.md
        for index in [44, 501, 0, 0] {
            derivedKey = try derivedKey.derive(Int32(index))
        }
        return derivedKey
    }
    
    
    public func derive(_ index: Int32) throws -> Ed25519HierachicalPrivateKey {
        var hmac = HMAC<SHA512>.init(key: chainCode)
        hmac.update(data: [UInt8(0)])
        hmac.update(data: privateKey.rawRepresentation)
        var indexBytes = index.beBytes
        indexBytes[0] = indexBytes[0] | 0x80
        hmac.update(data: indexBytes)
        return try Ed25519HierachicalPrivateKey(
            data: Data(hmac.finalize())
        )
    }
}

extension Int32 {
    var beBytes: [UInt8] {
        var bigEndian = self.bigEndian
        return withUnsafeBytes(of: &bigEndian) { Array($0) }
    }
}
