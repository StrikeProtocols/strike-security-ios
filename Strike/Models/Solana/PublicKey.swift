//
//  File.swift
//
//
//  Created by Brendan Flood on 12/8/21.
//
import Foundation

struct PublicKey: Codable, Equatable, CustomStringConvertible, Hashable {
    public static let numberOfBytes = 32
    public let bytes: [UInt8]

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(base58EncodedString)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        try self.init(string: string)
    }

    public init(string: String?) throws {
        guard let string = string, string.utf8.count >= PublicKey.numberOfBytes
        else {
            throw SolanaError.other("Invalid public key input")
        }
        let bytes = Base58.decode(string)
        self.bytes = bytes
    }

    public init(data: Data) throws {
        guard data.count <= PublicKey.numberOfBytes else {
            throw SolanaError.other("Invalid public key input")
        }
        self.bytes = [UInt8](data)
    }

    public init(bytes: [UInt8]?) throws {
        guard let bytes = bytes, bytes.count <= PublicKey.numberOfBytes else {
            throw SolanaError.other("Invalid public key input")
        }
        self.bytes = bytes
    }

    public var base58EncodedString: String {
        Base58.encode(bytes)
    }

    public var data: Data {
        Data(bytes)
    }

    public var description: String {
        base58EncodedString
    }

    public func short(numOfSymbolsRevealed: Int = 4) -> String {
        let pubkey = base58EncodedString
        return pubkey.prefix(numOfSymbolsRevealed) + "..." + pubkey.suffix(numOfSymbolsRevealed)
    }
}
