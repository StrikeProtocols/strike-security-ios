//
//  File.swift
//
//
//  Created by Brendan Flood on 12/8/21.
//
import Foundation
import CryptoKit

let SYSVAR_CLOCK_PUBKEY = try! PublicKey(string: "SysvarC1ock11111111111111111111111111111111")
let SYSVAR_RENT_PUBKEY = try! PublicKey(string: "SysvarRent111111111111111111111111111111111")
let SYS_PROGRAM_ID = try! PublicKey(string: "11111111111111111111111111111111")
let TOKEN_PROGRAM_ID = try! PublicKey(string: "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA")
let ASSOCIATED_TOKEN_PROGRAM_ID = try! PublicKey(string: "ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL")
let WRAPPED_SOL_MINT = try! PublicKey(string: "So11111111111111111111111111111111111111112")
let RECENT_BLOCKHASHES_SYSVAR_ID = try! PublicKey(string: "SysvarRecentB1ockHashes11111111111111111111")
let EMPTY_KEY = try! PublicKey(string: "11111111111111111111111111111111")

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

// MARK: - Constants
private var maxSeedLength = 32
private let gf1 = NaclLowLevel.gf([1])

private extension Int {
    func toBool() -> Bool {
        self != 0
    }
}

extension PublicKey {
    public static func associatedTokenAddress(
        walletAddress: PublicKey,
        tokenMintAddress: PublicKey
    ) -> Result<PublicKey, Error> {
        return findProgramAddress(
            seeds: [
                walletAddress.data,
                TOKEN_PROGRAM_ID.data,
                tokenMintAddress.data
            ],
            programId: ASSOCIATED_TOKEN_PROGRAM_ID
        ).map { $0.0 }
    }

    // MARK: - Helpers
    private static func findProgramAddress(
        seeds: [Data],
        programId: Self
    ) -> Result<(Self, UInt8), Error> {
        for nonce in stride(from: UInt8(255), to: 0, by: -1) {
            let seedsWithNonce = seeds + [Data([nonce])]
            if case .success(let publicKey) = createProgramAddress(seeds: seedsWithNonce, programId: programId) {
                return .success((publicKey, nonce))
            }
        }
        return .failure(SolanaError.notFoundProgramAddress)
    }

    private static func createProgramAddress(
        seeds: [Data],
        programId: PublicKey
    ) ->  Result<PublicKey, Error> {
        // construct data
        var data = Data()
        for seed in seeds {
            if seed.bytes.count > maxSeedLength {
                return .failure(SolanaError.other("Max seed length exceeded"))
            }
            data.append(seed)
        }
        data.append(programId.data)
        data.append("ProgramDerivedAddress".data(using: .utf8)!)

        // hash it
        let hash = Data(SHA256.hash(data:data))
        let publicKeyBytes = Bignum(number: hash.hexEncodedString(), withBase: 16).data

        // check it
        if isOnCurve(publicKeyBytes: publicKeyBytes).toBool() {
            return .failure(SolanaError.other("Invalid seeds, address must fall off the curve"))
        }
        guard let newKey = try? PublicKey(data: publicKeyBytes) else {
            return .failure(SolanaError.invalidPublicKey)
        }
        return .success(newKey)
    }

    private static func isOnCurve(publicKeyBytes: Data) -> Int {
        var r = [[Int64]](repeating: NaclLowLevel.gf(), count: 4)

        var t = NaclLowLevel.gf(),
            chk = NaclLowLevel.gf(),
            num = NaclLowLevel.gf(),
            den = NaclLowLevel.gf(),
            den2 = NaclLowLevel.gf(),
            den4 = NaclLowLevel.gf(),
            den6 = NaclLowLevel.gf()

        NaclLowLevel.set25519(&r[2], gf1)
        NaclLowLevel.unpack25519(&r[1], publicKeyBytes.bytes)
        NaclLowLevel.S(&num, r[1])
        NaclLowLevel.M(&den, num, NaclLowLevel.D)
        NaclLowLevel.Z(&num, num, r[2])
        NaclLowLevel.A(&den, r[2], den)

        NaclLowLevel.S(&den2, den)
        NaclLowLevel.S(&den4, den2)
        NaclLowLevel.M(&den6, den4, den2)
        NaclLowLevel.M(&t, den6, num)
        NaclLowLevel.M(&t, t, den)

        NaclLowLevel.pow2523(&t, t)
        NaclLowLevel.M(&t, t, num)
        NaclLowLevel.M(&t, t, den)
        NaclLowLevel.M(&t, t, den)
        NaclLowLevel.M(&r[0], t, den)

        NaclLowLevel.S(&chk, r[0])
        NaclLowLevel.M(&chk, chk, den)
        if NaclLowLevel.neq25519(chk, num).toBool() {
            NaclLowLevel.M(&r[0], r[0], NaclLowLevel.I)
        }

        NaclLowLevel.S(&chk, r[0])
        NaclLowLevel.M(&chk, chk, den)

        if NaclLowLevel.neq25519(chk, num).toBool() {
            return 0
        }
        return 1
    }
}
