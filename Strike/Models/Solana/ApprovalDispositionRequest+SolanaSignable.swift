//
//  ApprovalDispositionRequest+SolanaSignable.swift
//  Strike
//
//  Created by Ata Namvari on 2022-03-10.
//

import Foundation
import CryptoKit

extension StrikeApi.ApprovalDispositionRequest: SolanaSignable {
    var opIndex: UInt8 {
        return 9
    }

    var opCode: UInt8 {
        switch requestType {
        case .balanceAccountCreation:
            return 1
        case .withdrawalRequest:
            return 3
        case .conversionRequest:
            return 3
        case .signersUpdate:
            return 5
        case .dAppTransactionRequest:
            return 0
        case .unknown:
            return 0
        }
    }

    var solanaProgramValue: UInt8 {
        switch disposition {
        case .Approve:
            return 1
        case .Deny:
            return 2
        }
    }

    var opHashData: Data {
        get throws {
            switch requestType {
            case .balanceAccountCreation(let request):
                return try Data(
                    [opCode] +
                    signingData.walletAddress.base58Bytes +
                    request.accountInfo.identifier.sha256HashBytes +
                    [request.accountSlot] +
                    request.accountInfo.name.sha256HashBytes +
                    [request.approvalsRequired] +
                    request.approvalTimeout.convertToSeconds.bytes +
                    ([UInt8(request.approvers.count)] as [UInt8]) +
                    (request.approvers.flatMap(\.combinedBytes) as [UInt8]) +
                    ([request.whitelistEnabled.toSolanaProgramValue()] as [UInt8]) +
                    ([request.dappsEnabled.toSolanaProgramValue()] as [UInt8]) +
                    ([request.addressBookSlot] as [UInt8])
                )
            case .withdrawalRequest(let request):
                return try Data(
                    [opCode] +
                    signingData.walletAddress.base58Bytes +
                    request.account.identifier.sha256HashBytes +
                    request.destination.address.base58Bytes +
                    request.symbolAndAmountInfo.fundamentalAmount.bytes +
                    request.symbolAndAmountInfo.symbolInfo.tokenMintAddress.base58Bytes
                )
            case .conversionRequest(let request):
                return try Data(
                    [opCode] +
                    signingData.walletAddress.base58Bytes +
                    request.account.identifier.sha256HashBytes +
                    request.destination.address.base58Bytes +
                    request.symbolAndAmountInfo.fundamentalAmount.bytes +
                    request.symbolAndAmountInfo.symbolInfo.tokenMintAddress.base58Bytes
                )
            case .signersUpdate(let request):
                return try Data(
                    [opCode] +
                    signingData.walletAddress.base58Bytes +
                    [request.slotUpdateType.toSolanaProgramValue()] +
                    request.signer.combinedBytes
                )
            case .dAppTransactionRequest:
                throw SolanaError.invalidRequest(reason: "Invalid request for Approval")
            case .unknown:
                throw SolanaError.invalidRequest(reason: "Unknown Approval")
            }
        }
    }

    var signingData: SolanaSigningData {
        get throws {
            switch requestType {
            case .balanceAccountCreation(let request):
                return request.signingData
            case .withdrawalRequest(let request):
                return request.signingData
            case .conversionRequest(let request):
                return request.signingData
            case .signersUpdate(let request):
                return request.signingData
            case .dAppTransactionRequest:
                throw SolanaError.invalidRequest(reason: "Invalid request for Approval")
            case .unknown:
                throw SolanaError.invalidRequest(reason: "Unknown Approval")
            }
        }
    }

    var transactionInstructionData: Data {
        get throws {
            var data = Data()
            data.append(contentsOf: [opIndex])
            data.append(contentsOf: [solanaProgramValue])
            let opHash = try Data(SHA256.hash(data: opHashData))
            data.append(opHash)
            return data
        }
    }

    func signableData(approverPublicKey: String) throws -> Data {
        return try Transaction.compileMessage(
            feePayer: try PublicKey(string: signingData.feePayer),
            recentBlockhash: blockhash.value,
            instructions: [
                TransactionInstruction(
                    keys: [
                        Account.Meta(publicKey: try PublicKey(string: signingData.multisigOpAccountAddress), isSigner: false, isWritable: true),
                        Account.Meta(publicKey: PublicKey(string: approverPublicKey), isSigner: true, isWritable: false),
                        Account.Meta(publicKey: SYSVAR_CLOCK_PUBKEY, isSigner: false, isWritable: false)
                    ],
                    programId: PublicKey(string: signingData.walletProgramId),
                    data: [UInt8](transactionInstructionData)
                )
            ]
        ).serialize()
    }
}

extension SymbolAndAmountInfo {
    enum AmountError: Error {
        case invalidDecimal
    }

    var fundamentalAmount: UInt64 {
        get throws {
            guard let decimal = Decimal(string: amount) else { throw AmountError.invalidDecimal }

            if symbolInfo.symbol == "SOL" {
                return NSDecimalNumber(decimal: decimal * 1_000_000_000).uint64Value
            } else {
                let precisionParts = amount.components(separatedBy: ".")
                let decimals = precisionParts.count == 1 ? 0 : precisionParts[1].count

                return NSDecimalNumber(decimal: decimal * pow(10, decimals)).uint64Value
            }
        }
    }
}

extension SlotSignerInfo {
    var combinedBytes: [UInt8] {
        return [slotId] + value.publicKey.base58Bytes
    }
}

extension String {
    var base58Bytes: [UInt8] {
        Base58.decode(self)
    }
}

extension String {
    var sha256HashBytes: [UInt8] {
        Data(SHA256.hash(data: Data(utf8))).bytes
    }
}

extension UInt64 {
    var convertToSeconds: UInt64 {
        return self / 1000
    }
    
    var bytes: [UInt8] {
        var littleEndian = self.littleEndian
        return withUnsafeBytes(of: &littleEndian) { Array($0) }
    }
}

extension UInt32 {
    
    var bytes: [UInt8] {
        var littleEndian = self.littleEndian
        return withUnsafeBytes(of: &littleEndian) { Array($0) }
    }
}

extension UInt16 {
    
    var bytes: [UInt8] {
        var littleEndian = self.littleEndian
        return withUnsafeBytes(of: &littleEndian) { Array($0) }
    }
}

enum SolanaError: Error, Equatable {
    case other(String)
    case invalidRequest(reason: String? = nil)
    case notFoundProgramAddress
    case invalidPublicKey
}
