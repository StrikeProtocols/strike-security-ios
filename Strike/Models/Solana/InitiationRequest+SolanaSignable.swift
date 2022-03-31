//
//  File.swift
//  Strike
//
//  Created by Brendan Flood on 3/25/22.
//

import Foundation
import CryptoKit

extension StrikeApi.InitiationRequest: SolanaSignable, SolanaSignableSupplyInstructions {

    var opCode: UInt8 {
        switch requestType {
        case .balanceAccountCreation:
            return 3
        case .withdrawalRequest:
            return 7
        case .conversionRequest:
            return 7
        case .signersUpdate:
            return 12
        case .dAppTransactionRequest:
            return 16
        default:
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
    
    var opAccountPublicKey: PublicKey {
        get throws {
            try PublicKey(string: Base58.encode(opAccountPrivateKey.publicKey.rawRepresentation.bytes))
        }
    }
    
    var dataAccountPublicKey: PublicKey {
        get throws {
            guard let privateKey = dataAccountPrivateKey else {
                throw SolanaError.invalidRequest(reason: "Missing data account private key")
            }
            return try PublicKey(string: Base58.encode(privateKey.publicKey.rawRepresentation.bytes))
        }
    }
    
    var createOpAccountMeta: [Account.Meta] {
        get throws {
            try [
                Account.Meta(publicKey: PublicKey(string: signingData.feePayer), isSigner: true, isWritable: true),
                Account.Meta(publicKey: opAccountPublicKey, isSigner: true, isWritable: true)
            ]
        }
    }
    
    var createOpAccountInstruction: TransactionInstruction {
        get throws {
            try TransactionInstruction(
                keys: try createOpAccountMeta,
                programId: SYS_PROGRAM_ID,
                data: [UInt8](createOpAccounTransactionInstructionData)
            )
        }
    }
    
    var createOpAccounTransactionInstructionData: Data {
        get throws {
            try Data(
                UInt32(0).bytes +
                initiation.opAccountCreationInfo.minBalanceForRentExemption.bytes +
                initiation.opAccountCreationInfo.accountSize.bytes +
                signingData.walletProgramId.base58Bytes
            )
        }
    }
    
    var createDataAccountMeta: [Account.Meta] {
        get throws {
            try [
                Account.Meta(publicKey: PublicKey(string: signingData.feePayer), isSigner: true, isWritable: true),
                Account.Meta(publicKey: dataAccountPublicKey, isSigner: true, isWritable: true)
            ]
        }
    }
    
    var createDataAccountInstruction: TransactionInstruction {
        get throws {
            try TransactionInstruction(
                keys: try createDataAccountMeta,
                programId: SYS_PROGRAM_ID,
                data: [UInt8](createDataAccounTransactionInstructionData)
            )
        }
    }
    
    var createDataAccounTransactionInstructionData: Data {
        get throws {
            guard let dataAccountCreationInfo = initiation.dataAccountCreationInfo else {
                throw SolanaError.invalidRequest(reason: "Missing data account creation")
            }
            return try Data(
                UInt32(0).bytes +
                dataAccountCreationInfo.minBalanceForRentExemption.bytes +
                dataAccountCreationInfo.accountSize.bytes +
                signingData.walletProgramId.base58Bytes
            )
        }
    }
    

    var instructionData: Data {
        get throws {
            switch requestType {
            case .balanceAccountCreation(let request):
                return Data(
                    [opCode] +
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
                    request.account.identifier.sha256HashBytes +
                    request.symbolAndAmountInfo.fundamentalAmount.bytes +
                    request.destination.name.sha256HashBytes
                )
            case .conversionRequest(let request):
                return try Data(
                    [opCode] +
                    request.account.identifier.sha256HashBytes +
                    request.symbolAndAmountInfo.fundamentalAmount.bytes +
                    request.destination.name.sha256HashBytes
                )
            case .signersUpdate(let request):
                return Data(
                    [opCode] +
                    [request.slotUpdateType.toSolanaProgramValue()] +
                    request.signer.combinedBytes
                )
            case .dAppTransactionRequest(let request):
                return Data(
                    [opCode] +
                    request.account.identifier.sha256HashBytes +
                    request.dAppInfo.address.base58Bytes +
                    request.dAppInfo.name.sha256HashBytes +
                    ([UInt8(request.instructions.map { $0.instructions.count }.reduce(0, +))])
                )
            default:
                throw SolanaError.invalidRequest(reason: "Unknown Approval")
            }
        }
    }
    
    var supplyInstructions: [SolanaInstructionBatch] {
        get throws {
            switch requestType {
            case .dAppTransactionRequest(let request):
                return request.instructions
            default:
                return []
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
            case .dAppTransactionRequest(let request):
                return request.signingData
            default:
                throw SolanaError.invalidRequest(reason: "Unknown Initiation")
            }
        }
    }
    
    func instructionAccountMeta(approverPublicKey: PublicKey) throws -> [Account.Meta] {
        switch requestType {
        case .withdrawalRequest(let request):
            return try getTransferAndConversionAccounts(
                sourceAddress: request.account.address!,
                destinationAddress: request.destination.address,
                tokenMintAddress: request.symbolAndAmountInfo.symbolInfo.tokenMintAddress,
                approverPublicKey: approverPublicKey
            )
        case .conversionRequest(let request):
            return try getTransferAndConversionAccounts(
                sourceAddress: request.account.address!,
                destinationAddress: request.destination.address,
                tokenMintAddress: request.symbolAndAmountInfo.symbolInfo.tokenMintAddress,
                approverPublicKey: approverPublicKey
            )
        case .dAppTransactionRequest:
            return [
                Account.Meta(publicKey: try opAccountPublicKey, isSigner: false, isWritable: true),
                Account.Meta(publicKey: try dataAccountPublicKey, isSigner: false, isWritable: true),
                Account.Meta(publicKey: try PublicKey(string: signingData.walletAddress), isSigner: false, isWritable: false),
                Account.Meta(publicKey: approverPublicKey, isSigner: true, isWritable: false),
                Account.Meta(publicKey: SYSVAR_CLOCK_PUBKEY, isSigner: false, isWritable: false)
            ]
        default:
            return [
                Account.Meta(publicKey: try opAccountPublicKey, isSigner: false, isWritable: true),
                Account.Meta(publicKey: try PublicKey(string: signingData.walletAddress), isSigner: false, isWritable: false),
                Account.Meta(publicKey: approverPublicKey, isSigner: true, isWritable: false),
                Account.Meta(publicKey: SYSVAR_CLOCK_PUBKEY, isSigner: false, isWritable: false)
            ]
        }
    }
    
    func getTransferAndConversionAccounts(sourceAddress: String, destinationAddress: String, tokenMintAddress: String, approverPublicKey: PublicKey) throws -> [Account.Meta] {
        let sourcePublicKey = try PublicKey(string: sourceAddress)
        let tokenMintPublicKey = try PublicKey(string: tokenMintAddress)
        let destinationPublicKey = try PublicKey(string: destinationAddress)
        var destinationTokenAddress = EMPTY_KEY
        if tokenMintPublicKey != EMPTY_KEY {
            destinationTokenAddress = try PublicKey.associatedTokenAddress(walletAddress: destinationPublicKey,
                                                                           tokenMintAddress: tokenMintPublicKey).get()
        }
        return [
            Account.Meta(publicKey: try opAccountPublicKey, isSigner: false, isWritable: true),
            Account.Meta(publicKey: try PublicKey(string: signingData.walletAddress), isSigner: false, isWritable: false),
            Account.Meta(publicKey: sourcePublicKey, isSigner: false, isWritable: true),
            Account.Meta(publicKey: destinationPublicKey, isSigner: false, isWritable: false),
            Account.Meta(publicKey: approverPublicKey, isSigner: true, isWritable: false),
            Account.Meta(publicKey: SYSVAR_CLOCK_PUBKEY, isSigner: false, isWritable: false),
            Account.Meta(publicKey: tokenMintPublicKey, isSigner: false, isWritable: false),
            Account.Meta(publicKey: destinationTokenAddress, isSigner: false, isWritable: true),
            Account.Meta(publicKey: try PublicKey(string: signingData.feePayer), isSigner: true, isWritable: true),
            Account.Meta(publicKey: SYS_PROGRAM_ID, isSigner: false, isWritable: false),
            Account.Meta(publicKey: TOKEN_PROGRAM_ID, isSigner: false, isWritable: false),
            Account.Meta(publicKey: SYSVAR_RENT_PUBKEY, isSigner: false, isWritable: false),
            Account.Meta(publicKey: ASSOCIATED_TOKEN_PROGRAM_ID, isSigner: false, isWritable: false)
        ]
    }


    func signableData(approverPublicKey: String) throws -> Data {
        var instructions = [try createOpAccountInstruction]
        if initiation.dataAccountCreationInfo != nil {
            instructions.append(try createDataAccountInstruction)
        }
        instructions.append(try TransactionInstruction(
            keys: instructionAccountMeta(approverPublicKey: try PublicKey(string: approverPublicKey)),
            programId: PublicKey(string: signingData.walletProgramId),
            data: [UInt8](instructionData)
        ))
        return try Transaction.compileMessage(
            feePayer: PublicKey(string: signingData.feePayer),
            recentBlockhash: blockhash.value,
            instructions: instructions
        ).serialize()
    }
    
    func signableSupplyInstructions(approverPublicKey: String) throws -> [Data] {
        try supplyInstructions.map {
            try Transaction.compileMessage(
                feePayer: try PublicKey(string: signingData.feePayer),
                recentBlockhash: blockhash.value,
                instructions: [TransactionInstruction(
                    keys: [
                        Account.Meta(publicKey: try opAccountPublicKey, isSigner: false, isWritable: true),
                        Account.Meta(publicKey: try dataAccountPublicKey, isSigner: false, isWritable: true),
                        Account.Meta(publicKey: try PublicKey(string: approverPublicKey), isSigner: true, isWritable: false)
                    ],
                    programId: try PublicKey(string: signingData.walletProgramId),
                    data: [UInt8]($0.combinedBytes)
                    )
                ]
            ).serialize()
        }
    }
}


extension SolanaAccountMeta {
    var flags: UInt8 {
        return (writeable ? 1 : 0) + (signer ? 2 : 0)
    }
    
    var combinedBytes: [UInt8] {
        return [flags] + address.base58Bytes
    }
}

extension SolanaInstructionBatch {
    
    var combinedBytes: [UInt8] {
        return [UInt8](Data(
            [28] +
            ([from]) +
            UInt16(instructions.count).bytes +
            (instructions.flatMap(\.combinedBytes) as [UInt8])
        ))
    }
}

extension SolanaInstruction {
    
    var combinedBytes: [UInt8] {
        guard let b64DecodedData = Data(base64Encoded: data) else {
            return []
        }
        return [UInt8](Data(
            programId.base58Bytes +
            (UInt16(accountMetas.count).bytes) +
            (accountMetas.flatMap(\.combinedBytes) as [UInt8]) +
            (UInt16(b64DecodedData.count).bytes) +
            Data(base64Encoded: data)!
        ))
    }
}
