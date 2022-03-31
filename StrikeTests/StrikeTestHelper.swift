//
//  StrikeTestHelper.swift
//  StrikeTests
//
//  Created by Brendan Flood on 3/27/22.
//

import Foundation

import XCTest
@testable import Strike
import CryptoKit

extension StrikeTests {
    
    
    func getSignersUpdateRequest() ->  SolanaApprovalRequestType {
        return .signersUpdate(SignersUpdate(
                slotUpdateType: SlotUpdateType.Clear,
                signer: SlotSignerInfo(slotId: 2,
                                       value: SignerInfo(
                                        publicKey: "8UnsWLFHj8CWshTuK2jrny6mH2CtQCZf7gYrxkc36U26",
                                        name: "User 2",
                                        email: "user2@org1")),
                signingData: SolanaSigningData(
                    feePayer: "4s4NaGfvefXWFpUWMtLbqT65bFxp3328v7SXZzjXChLq",
                    walletProgramId: "6ognBK2bhBEDg45eVuoxfdALpy6FFXqimpnzCamxhwo5",
                    multisigOpAccountAddress: "11111111111111111111111111111111",
                    walletAddress: "FjqmMpiMTMYVsSmjmMt3erqTttjnRhWXqkNuCRYzaR77")
        ))
    }
            
    func getSignersUpdateRequest() ->  WalletApprovalRequest {
        return getWalletApprovalRequest(.signersUpdate(SignersUpdate(
                slotUpdateType: SlotUpdateType.SetIfEmpty,
                signer: SlotSignerInfo(slotId: 1,
                                       value: SignerInfo(
                                        publicKey: "6E5S1pMfe7DfBwYp2KmmYvTup2hduP385dhhoexX8i9",
                                        name: "User 2",
                                        email: "user2@org1")),
                signingData: SolanaSigningData(
                    feePayer: "8UT5JS7vVcGLBHQe19Q5EK6aFA2CYnFG8a5C4dkrTL2B",
                    walletProgramId: "JAbzU4jwUMn92xhZcAX4M6JANEigzVMKKJqy6pA1cNBT",
                    multisigOpAccountAddress: "Hx9JnkPHioA9eu92y7jho1TxNaBCHYbw8zaSxvkGXSdD",
                    walletAddress: "FWhBukWcdXaMqZhJMvAAEH6PH81nV6JSpBEmwdvWgUjW"))
                )
        )
    }
        
    func getBalanceAccountCreationRequest() -> SolanaApprovalRequestType {
        return .balanceAccountCreation(
            BalanceAccountCreation(
                accountSlot: 0,
                accountInfo: AccountInfo(
                    name: "Account 1",
                    identifier: "e1cf64d8-4f7c-4cca-8859-c94f27645aca",
                    accountType: AccountType.BalanceAccount,
                    address: nil
                ),
                approvalsRequired: 1,
                approvalTimeout: 3600000,
                approvers: [SlotSignerInfo(slotId: 0, value: SignerInfo(
                    publicKey: "6fbjW55k7m1ERjJ6cDKhHvpc6MryEyZyncpEXVd5EYKE",
                    name: "User 1",
                    email: "authorized1@org1"
                ))],
                whitelistEnabled: BooleanSetting.Off,
                dappsEnabled: BooleanSetting.Off,
                addressBookSlot: 0,
                signingData: SolanaSigningData(
                    feePayer: "CCBSbhNarxjfL7njJApxz6VKaXjJ8z9b1QjML91pp8MT",
                    walletProgramId: "HocP5yBGUdwRpk5YWuHiRDHN3pBu7hbdGHSMHY8oE4Qn",
                    multisigOpAccountAddress: "Hqqp4eXDCbKkV5VedFmd6wfirjyrZsP73U62nNMEFbvc",
                    walletAddress: "8v5siTf1GwSDMqDDDbkY5ecc1mPmMdv73ikzduHP28X6"
                )
            )
        )
    }
    
    func getSolWithdrawalRequest() -> SolanaApprovalRequestType {
        return .withdrawalRequest(
            WithdrawalRequest(
                account: AccountInfo(
                    name: "Account 1",
                    identifier: "aca70ed8-f935-444d-909a-8880eed2dfb9",
                    accountType: AccountType.BalanceAccount,
                    address: "De4BuvcEGMuhnsxWMDg2nkgx5o3MVGZBJTcivb35Kxqu"
                ),
                symbolAndAmountInfo: SymbolAndAmountInfo(
                    symbolInfo: SymbolInfo(
                        symbol: "SOL",
                        symbolDescription: "Solana",
                        tokenMintAddress: "11111111111111111111111111111111"
                    ),
                    amount: "0.500000000",
                    usdEquivalent: "44.39"
                ),
                destination: DestinationAddress(
                    name: "My External Sol address",
                    subName: nil,
                    address: "7hy5MmnD2tKZmbKW7zudTuotQo3zKHy6hZDSN7s14Ei7",
                    tag: nil
                ),
                signingData: SolanaSigningData(
                    feePayer: "4JF32seVZrXSQLdd73U8ummME5bqj3GY7ntZ8XTqLQix",
                    walletProgramId: "Y2KY1ez5XzAQ8nt5462cmycqwZ6kALx8bYFQmVpuAKL",
                    multisigOpAccountAddress: "11111111111111111111111111111111",
                    walletAddress: "2qv5ztmLr7BcnpTjckpbsiMkcmFYL24Hd2LftWktXLRn"
                )
            )
        )
    }
    
    func getSplWithdrawalRequest() -> SolanaApprovalRequestType {
        return .withdrawalRequest(
            WithdrawalRequest(
                account: AccountInfo(
                    name: "Account 1",
                    identifier: "3462c709-c2c9-465e-8dfa-a6935913dbd5",
                    accountType: AccountType.BalanceAccount,
                    address: "CYt79VV8YVywKZpyqPmvtwjVBv7hNCmrkJQifJV1kpfy"
                ),
                symbolAndAmountInfo: SymbolAndAmountInfo(
                    symbolInfo: SymbolInfo(
                        symbol: "soTEST",
                        symbolDescription: "Test SPL token",
                        tokenMintAddress: "2XMDev5aNtfyDMVyPhSuo5AE13maL4L4tWavReQMfBFd"
                    ),
                    amount: "0.000500",
                    usdEquivalent: nil
                ),
                destination: DestinationAddress(
                    name: "Org1 Sol Wallet",
                    subName: nil,
                    address: "49KyG8iw5GkX6CLASyC7aPBoMDtXpXVzZUFTcpDK2svB",
                    tag: nil
                ),
                signingData: SolanaSigningData(
                    feePayer: "D5a4yAj2WZt3bhBLg5YCBwu89GqYhSD5iCK3FmczmEe1",
                    walletProgramId: "5GMeqZyWCGAgq67eQ6pc5UGw61RRCysSzfz7jmchDpTw",
                    multisigOpAccountAddress: "11111111111111111111111111111111",
                    walletAddress: "9CRdtQ5su7cP3bSwsdeTU8bRAuxhKkemUrNP7URvTaQS"
                )
            )
        )
    }

    func getConversionRequest() -> SolanaApprovalRequestType {
        return .conversionRequest(
            ConversionRequest(
                account: AccountInfo(
                    name: "Account 1",
                    identifier: "9826889c-df77-4c5b-b4ad-9bde935e6c52",
                    accountType: AccountType.BalanceAccount,
                    address: "F8MQFSzgGtddamGjNNoFuUfrZNZkV84icnXwyMVo7Aa3"
                ),
                symbolAndAmountInfo: SymbolAndAmountInfo(
                    symbolInfo: SymbolInfo(
                        symbol: "USDC",
                        symbolDescription: "USD Coin",
                        tokenMintAddress: "ALmJ9wWY2o1FiLcSDuvHN3xH5UHLkYsVbz2JWD37MuUY"
                    ),
                    amount: "500.000000",
                    usdEquivalent: "500.00"
                ),
                destination: DestinationAddress(
                    name: "USDC Redemption Address",
                    subName: nil,
                    address: "Bt4cfS3fhtbCiB3uDXDRvft6SCVbHCH7Pz7kh66tzzKA",
                    tag: nil
                ),
                destinationSymbolInfo: SymbolInfo(
                    symbol: "USD",
                    symbolDescription: "US Dollar",
                    tokenMintAddress: "11111111111111111111111111111111"
                ),
                signingData: SolanaSigningData(
                    feePayer: "FBiyhqgyrv6iRejRgL9tDYxB2jtEB4RH9pnPK2CN5J4m",
                    walletProgramId: "CH2nLW24j2Wd1geFGSKkJmbAz1KLhACR9RRD1wHgCH74",
                    multisigOpAccountAddress: "11111111111111111111111111111111",
                    walletAddress: "2sGiNkpwYod6c1Wcd6H1ycd85KwykMfb8ZCt7t3XEp4h"
                )
            )
        )
    }
    
    func getDAppTransactionRequest() -> SolanaApprovalRequestType {
        return .dAppTransactionRequest(
            DAppTransactionRequest(
                account: AccountInfo(
                    name: "Account 1",
                    identifier: "e5792728-0ba8-4332-8d2d-bd86cab1fbb6",
                    accountType: AccountType.BalanceAccount,
                    address: "51XimWWEALnZ2hsybTY2kLeLSwDuKkRMyQvZuen93LHn"
                ),
                dAppInfo: SolanaDApp(
                    address: "ECGifmb7hqUCePXgs6Df5Vrpip9QZXSyQfqLHp8vueYm",
                    name: "DApp Name",
                    logo: "dapp-icon"
                ),
                balanceChanges: [],
                instructions: [
                    SolanaInstructionBatch(
                        from: 0,
                        instructions: [
                            SolanaInstruction(
                                programId: "ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL",
                                accountMetas: [
                                    SolanaAccountMeta(address: "51XimWWEALnZ2hsybTY2kLeLSwDuKkRMyQvZuen93LHn", signer: true, writeable: true),
                                    SolanaAccountMeta(address: "28u8Cv5HrYgxYe96xj3rH19P2wMZN9Z77b3jqwRFsdP3", signer: false, writeable: true),
                                    SolanaAccountMeta(address: "51XimWWEALnZ2hsybTY2kLeLSwDuKkRMyQvZuen93LHn", signer: true, writeable: true),
                                    SolanaAccountMeta(address: "GcrfZehbg9fYkZ9C8EjTTh2gZ1dkpyJQUzQmWTKXN837", signer: false, writeable: false),
                                    SolanaAccountMeta(address: "11111111111111111111111111111111", signer: false, writeable: false),
                                    SolanaAccountMeta(address: "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA", signer: false, writeable: false),
                                    SolanaAccountMeta(address: "SysvarRent111111111111111111111111111111111", signer: false, writeable: false),
                                ],
                                data: "AQIDrA=="
                            )
                        ]
                    )
                ],
                signingData: SolanaSigningData(
                    feePayer: "87VXbkJsqdDvXYfDBtS4kW4TcFor7ogofZXbXjT7t7AU",
                    walletProgramId: "GPD4r7wKZkaqoVKeJwvwNp6RECKytDTmxmxNe6UE6n2d",
                    multisigOpAccountAddress: "11111111111111111111111111111111",
                    walletAddress: "J3JWJ7K5nCcUxce9MyXJxXZG3LxSmAuzwWaQqcbWCeP8"
                )
            )
        )
    }
    
    
    func getWalletApprovalRequest(_ requestType: SolanaApprovalRequestType) -> WalletApprovalRequest {
        return WalletApprovalRequest(
            id: "1",
            walletType: WalletType.Solana,
            submitterName: "",
            submitterEmail: "",
            submitDate: Date(),
            approvalTimeoutInSeconds: 1000,
            numberOfDispositionsRequired: 1,
            numberOfApprovalsReceived: 1,
            numberOfDeniesReceived: 1,
            details: .approval(requestType)
        )
    }

    func getWalletInitiationRequest(_ requestType: SolanaApprovalRequestType, initiation: MultisigOpInitiation) -> WalletApprovalRequest {
        return WalletApprovalRequest(
            id: "1",
            walletType: WalletType.Solana,
            submitterName: "",
            submitterEmail: "",
            submitDate: Date(),
            approvalTimeoutInSeconds: 1000,
            numberOfDispositionsRequired: 1,
            numberOfApprovalsReceived: 1,
            numberOfDeniesReceived: 1,
            details: .multisigOpInitiation(initiation, requestType: requestType)
        )
    }
    
    func getOpAccountCreationInfo() -> MultisigAccountCreationInfo {
        return MultisigAccountCreationInfo(
            accountSize: 848,
            minBalanceForRentExemption: 6792960
        )
    }
    
    func getRecentBlockhash(_ hash: String) -> StrikeApi.Blockhash {
        return StrikeApi.Blockhash(
            id: "1",
            result: StrikeApi.Blockhash.Result(
                value: StrikeApi.Blockhash.Result.BlockhashData(blockhash: hash)
            )
        )
    }
}

extension String {
    enum ExtendedEncoding {
        case hexadecimal
    }

    func data(using encoding:ExtendedEncoding) -> Data? {
        switch encoding {
        case .hexadecimal:
            let hexStr = self.dropFirst(self.hasPrefix("0x") ? 2 : 0)

            var newData = Data(capacity: hexStr.count/2)

            var indexIsEven = true
            for i in hexStr.indices {
                if indexIsEven {
                    let byteRange = i...hexStr.index(after: i)
                    guard let byte = UInt8(hexStr[byteRange], radix: 16) else { return nil }
                    newData.append(byte)
                }
                indexIsEven.toggle()
            }
            return newData
        }
    }

}
