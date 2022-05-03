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
    
    
    func getSignersUpdateRequest(nonceAccountAddresses: [String]) ->  SolanaApprovalRequestType {
        return .signersUpdate(SignersUpdate(
                slotUpdateType: SlotUpdateType.Clear,
                signer: SlotSignerInfo(slotId: 2,
                                       value: SignerInfo(
                                        publicKey: "8hyAhcNRc1WS1eZxNy4keGC9mbGoyXZkx75qxmwM3hUc",
                                        name: "User 3",
                                        email: "user3@org1")),
                signingData: SolanaSigningData(
                    feePayer: "FM36ah2bH8nQWJNPCRzu7R69gE5o6UhujqJFtDpWN5as",
                    walletProgramId: "8pPAcjFSByreFRnRm5YyAdBP2LfiNnWBtBzHtRDcJpUA",
                    multisigOpAccountAddress: "SLnWXM1QTraLWFhCm7JxDZk11PBE5Gu524ASzAC6YjW",
                    walletAddress: "ECzeaMTMBXYXXfVM53n5iPepf8749QUqEzjW8jxefGhh",
                    nonceAccountAddresses: nonceAccountAddresses
                )
        ))
    }
            
    func getSignersUpdateWalletRequest(nonceAccountAddresses: [String]) ->  WalletApprovalRequest {
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
                    walletAddress: "FWhBukWcdXaMqZhJMvAAEH6PH81nV6JSpBEmwdvWgUjW",
                    nonceAccountAddresses: nonceAccountAddresses))
                )
        )
    }
        
    func getBalanceAccountCreationRequest(nonceAccountAddresses: [String]) -> SolanaApprovalRequestType {
        return .balanceAccountCreation(
            BalanceAccountCreation(
                accountSlot: 0,
                accountInfo: AccountInfo(
                    name: "Account 1",
                    identifier: "1ac4a7fc-d2f8-4c32-8707-7496ee958933",
                    accountType: AccountType.BalanceAccount,
                    address: nil
                ),
                approvalPolicy: ApprovalPolicy(
                    approvalsRequired: 1,
                    approvalTimeout: 3600000,
                    approvers: [SlotSignerInfo(slotId: 0, value: SignerInfo(
                        publicKey: "4q8ApWsB3rSW2HPFwc1aWmGgcBMfj7tSKBbb5sBGAB6h",
                        name: "User 1",
                        email: "authorized1@org1"
                    ))]
                ),
                whitelistEnabled: BooleanSetting.Off,
                dappsEnabled: BooleanSetting.Off,
                addressBookSlot: 0,
                signingData: SolanaSigningData(
                    feePayer: "FM36ah2bH8nQWJNPCRzu7R69gE5o6UhujqJFtDpWN5as",
                    walletProgramId: "8pPAcjFSByreFRnRm5YyAdBP2LfiNnWBtBzHtRDcJpUA",
                    multisigOpAccountAddress: "HypFjU4nfRYwdnNQTyJw8TFxYekptWTQNrTcW7ofMZxu",
                    walletAddress: "ECzeaMTMBXYXXfVM53n5iPepf8749QUqEzjW8jxefGhh",
                    nonceAccountAddresses: nonceAccountAddresses
                )
            )
        )
    }
    
    func getSolWithdrawalRequest(nonceAccountAddresses: [String]) -> SolanaApprovalRequestType {
        return .withdrawalRequest(
            WithdrawalRequest(
                account: AccountInfo(
                    name: "Account 1",
                    identifier: "9f3093c7-5b77-4ce4-b718-d47030bfdf3f",
                    accountType: AccountType.BalanceAccount,
                    address: "2AhhYePazh7dekyu9Ug8Vfp7weVCs3UgefLKq2pwpMzo"
                ),
                symbolAndAmountInfo: SymbolAndAmountInfo(
                    symbolInfo: SymbolInfo(
                        symbol: "SOL",
                        symbolDescription: "Solana",
                        tokenMintAddress: "11111111111111111111111111111111"
                    ),
                    amount: "0.200000000",
                    usdEquivalent: "17.75"
                ),
                destination: DestinationAddress(
                    name: "My External Sol address",
                    subName: nil,
                    address: "AzntcKp4TjdgRakBBorz6Tp2kC4PQg4gkDgrr9khCETU",
                    tag: nil
                ),
                signingData: SolanaSigningData(
                    feePayer: "FM36ah2bH8nQWJNPCRzu7R69gE5o6UhujqJFtDpWN5as",
                    walletProgramId: "AG23jVQ5EftDonUwCMhgXtr4jQAPdhAtPFw4y84CMeuj",
                    multisigOpAccountAddress: "9NDFtaczqouZ9SGTfd489EfN3KvMQgrAjpuu4QEr9Kys",
                    walletAddress: "CV3Xhgcs48U5o6CnabtjngKbR7H5dxpzJxpfZqBeEMfV",
                    nonceAccountAddresses: nonceAccountAddresses
                )
            )
        )
    }

    
    func getSplWithdrawalRequest(nonceAccountAddresses: [String]) -> SolanaApprovalRequestType {
        return .withdrawalRequest(
            WithdrawalRequest(
                account: AccountInfo(
                    name: "Account 1",
                    identifier: "5fb4556a-6de5-4a80-ac0e-6def9826384f",
                    accountType: AccountType.BalanceAccount,
                    address: "HT8kqgLxH5BsyA6Ah3oaAKG8SNAgzgRNH4uMfcAnUXTZ"
                ),
                symbolAndAmountInfo: SymbolAndAmountInfo(
                    symbolInfo: SymbolInfo(
                        symbol: "soTEST",
                        symbolDescription: "Test SPL token",
                        tokenMintAddress: "AZ6C941cFEv7EWUsPeeYYEK278Lw5wK4AVR6Mngdt9fr"
                    ),
                    amount: "0.000500",
                    usdEquivalent: nil
                ),
                destination: DestinationAddress(
                    name: "Org1 Sol Wallet",
                    subName: nil,
                    address: "7DhLZAT5buGyXpjpfRNKaHc1imjJaDzCXXTdM59JHrpQ",
                    tag: nil
                ),
                signingData: SolanaSigningData(
                    feePayer: "FM36ah2bH8nQWJNPCRzu7R69gE5o6UhujqJFtDpWN5as",
                    walletProgramId: "zeZ7E8F6UaNYy3ry3Mt6MGUSr679oTKV8tzXVe5B4bP",
                    multisigOpAccountAddress: "6UcFAr9rqGfFEtLxnYdW6QjeRor3aej5akLpYpXUkPWX",
                    walletAddress: "7fvoSJ6iNAyTFvBDuAWuciXWYiyUBtJfCUswZF3YGbUN",
                    nonceAccountAddresses: nonceAccountAddresses
                )
            )
        )
    }


    func getConversionRequest(nonceAccountAddresses: [String]) -> SolanaApprovalRequestType {
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
                    walletAddress: "2sGiNkpwYod6c1Wcd6H1ycd85KwykMfb8ZCt7t3XEp4h",
                    nonceAccountAddresses: nonceAccountAddresses
                )
            )
        )
    }
    
    func getWrapConversionRequest(nonceAccountAddresses: [String]) -> SolanaApprovalRequestType {
        return .wrapConversionRequest(
            WrapConversionRequest(
                account: AccountInfo(
                    name: "Account 1",
                    identifier: "82666cf4-3f31-4504-a1a2-5df9b35ba5b3",
                    accountType: AccountType.BalanceAccount,
                    address: "BSHKeDQL8NKBSmbX2M4svSqGL57qFhe7qvw72hpvgnZY"
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
                destinationSymbolInfo: SymbolInfo(
                    symbol: "wSOL",
                    symbolDescription: "Wrapped SOL",
                    tokenMintAddress: "11111111111111111111111111111111"
                ),
                signingData: SolanaSigningData(
                    feePayer: "FM36ah2bH8nQWJNPCRzu7R69gE5o6UhujqJFtDpWN5as",
                    walletProgramId: "DaGSQwGd1GZnscN2Mu5d1CPYqYXAQMV29Q4Zk9yDhZLp",
                    multisigOpAccountAddress: "11111111111111111111111111111111",
                    walletAddress: "Ebse7xEiKuhe3bWY6dXiWB8QS4QDhr8fRBgH4tUKR2Ys",
                    nonceAccountAddresses: nonceAccountAddresses
                )
            )
        )
    }
    
    func getUnwrapConversionRequest(nonceAccountAddresses: [String]) -> SolanaApprovalRequestType {
        return .wrapConversionRequest(
            WrapConversionRequest(
                account: AccountInfo(
                    name: "Account 1",
                    identifier: "82666cf4-3f31-4504-a1a2-5df9b35ba5b3",
                    accountType: AccountType.BalanceAccount,
                    address: "BSHKeDQL8NKBSmbX2M4svSqGL57qFhe7qvw72hpvgnZY"
                ),
                symbolAndAmountInfo: SymbolAndAmountInfo(
                    symbolInfo: SymbolInfo(
                        symbol: "wSOL",
                        symbolDescription: "Wrapped SOL",
                        tokenMintAddress: "11111111111111111111111111111111"
                    ),
                    amount: "0.300000000",
                    usdEquivalent: "26.63"
                ),
                destinationSymbolInfo: SymbolInfo(
                    symbol: "SOL",
                    symbolDescription: "Solana",
                    tokenMintAddress: "11111111111111111111111111111111"
                ),
                signingData: SolanaSigningData(
                    feePayer: "FM36ah2bH8nQWJNPCRzu7R69gE5o6UhujqJFtDpWN5as",
                    walletProgramId: "DaGSQwGd1GZnscN2Mu5d1CPYqYXAQMV29Q4Zk9yDhZLp",
                    multisigOpAccountAddress: "11111111111111111111111111111111",
                    walletAddress: "Ebse7xEiKuhe3bWY6dXiWB8QS4QDhr8fRBgH4tUKR2Ys",
                    nonceAccountAddresses: nonceAccountAddresses
                )
            )
        )
    }
    
    func getAddAddressBookEntry(nonceAccountAddresses: [String]) -> SolanaApprovalRequestType {
        return .addressBookUpdate(
            AddressBookUpdate(
                entriesToAdd: [
                    SlotDestinationInfo(
                        slotId: 1,
                        value: DestinationAddress(name: "My External Sol address 1", subName: nil, address: "6RsFJRJb2RxZG7kKFbnnKdei4bUmC51wBbEpZtm9AuzV", tag: nil)
                    ),
                    SlotDestinationInfo(
                        slotId: 2,
                        value: DestinationAddress(name: "My External Sol address 2", subName: nil, address: "CCusVse2bbV3KW6qDRuyLHGAp1i3mX4KvmQEd2urfotW", tag: nil)
                    ),
                    SlotDestinationInfo(
                        slotId: 3,
                        value: DestinationAddress(name: "My External Sol address 3", subName: nil, address: "BxrwUskF8LwKPy6KhddVPEDKPCPeQvEPcpkqy8RWqjgD", tag: nil)
                    ),
                    SlotDestinationInfo(
                        slotId: 4,
                        value: DestinationAddress(name: "My External Sol address 4", subName: nil, address: "9uknge22ixEFjGdVUESUGhskQBVv4TiAiLtyxzdKA7E1", tag: nil)
                    )
                ],
                entriesToRemove: [],
                whitelistUpdates: [],
                signingData: SolanaSigningData(
                    feePayer: "FM36ah2bH8nQWJNPCRzu7R69gE5o6UhujqJFtDpWN5as",
                    walletProgramId: "A2iHua5UQd6RWb6C3ZctQcfVZDoeG5pUvBtRQfWSxSqb",
                    multisigOpAccountAddress: "2Qr2bq8KpyAho1rSnE7TUwXgHW3UpM7KwYEijF11JF2d",
                    walletAddress: "FpyUo7gVxzB3mPVSkcHNdzdo1T6tNHvkzUvFajw2PwkG",
                    nonceAccountAddresses: nonceAccountAddresses
                ))
        )
    }
    
    func getAddressBookWhitelistUpdate(nonceAccountAddresses: [String]) -> SolanaApprovalRequestType {
        return .addressBookUpdate(
            AddressBookUpdate(
                entriesToAdd: [],
                entriesToRemove: [],
                whitelistUpdates: [ WhitelistUpdate(
                    account: AccountInfo(
                        name: "Account 1",
                        identifier: "a0c606ae-e1cc-4d1f-bed1-26c8a3fb61de",
                        accountType: AccountType.BalanceAccount,
                        address: "HphKLiDz5m6HGDov5tvKewBXawQwkVKQQWyreG7MJPNh"
                    ),
                    destinationsToAdd: [
                        SlotDestinationInfo(
                            slotId: 1,
                            value: DestinationAddress(name: "My External Sol address 1", subName: nil, address: "6RsFJRJb2RxZG7kKFbnnKdei4bUmC51wBbEpZtm9AuzV", tag: nil)
                        ),
                        SlotDestinationInfo(
                            slotId: 2,
                            value: DestinationAddress(name: "My External Sol address 2", subName: nil, address: "CCusVse2bbV3KW6qDRuyLHGAp1i3mX4KvmQEd2urfotW", tag: nil)
                        )
                    ],
                    destinationsToRemove: [])
                ],
                signingData: SolanaSigningData(
                    feePayer: "FM36ah2bH8nQWJNPCRzu7R69gE5o6UhujqJFtDpWN5as",
                    walletProgramId: "A2iHua5UQd6RWb6C3ZctQcfVZDoeG5pUvBtRQfWSxSqb",
                    multisigOpAccountAddress: "5NXoY3tbZGY2FMkF3W2tsEMn6Qdko5eViPThb4rvV3y1",
                    walletAddress: "FpyUo7gVxzB3mPVSkcHNdzdo1T6tNHvkzUvFajw2PwkG",
                    nonceAccountAddresses: nonceAccountAddresses
                ))
        )
    }
    
    
    func getAddressBookWhitelistAddAndRemove(nonceAccountAddresses: [String]) -> SolanaApprovalRequestType {
        return .addressBookUpdate(
            AddressBookUpdate(
                entriesToAdd: [],
                entriesToRemove: [],
                whitelistUpdates: [ WhitelistUpdate(
                    account: AccountInfo(
                        name: "Account 1",
                        identifier: "a0c606ae-e1cc-4d1f-bed1-26c8a3fb61de",
                        accountType: AccountType.BalanceAccount,
                        address: "HphKLiDz5m6HGDov5tvKewBXawQwkVKQQWyreG7MJPNh"
                    ),
                    destinationsToAdd: [
                        SlotDestinationInfo(
                            slotId: 3,
                            value: DestinationAddress(name: "My External Sol address 3", subName: nil, address: "BxrwUskF8LwKPy6KhddVPEDKPCPeQvEPcpkqy8RWqjgD", tag: nil)
                        ),
                        SlotDestinationInfo(
                            slotId: 4,
                            value: DestinationAddress(name: "My External Sol address 4", subName: nil, address: "9uknge22ixEFjGdVUESUGhskQBVv4TiAiLtyxzdKA7E1", tag: nil)
                        )
                    ],
                    destinationsToRemove: [
                        SlotDestinationInfo(
                            slotId: 1,
                            value: DestinationAddress(name: "My External Sol address 1", subName: nil, address: "6RsFJRJb2RxZG7kKFbnnKdei4bUmC51wBbEpZtm9AuzV", tag: nil)
                        ),
                        SlotDestinationInfo(
                            slotId: 2,
                            value: DestinationAddress(name: "My External Sol address 2", subName: nil, address: "CCusVse2bbV3KW6qDRuyLHGAp1i3mX4KvmQEd2urfotW", tag: nil)
                        )
                    ])
                ],
                signingData: SolanaSigningData(
                    feePayer: "FM36ah2bH8nQWJNPCRzu7R69gE5o6UhujqJFtDpWN5as",
                    walletProgramId: "A2iHua5UQd6RWb6C3ZctQcfVZDoeG5pUvBtRQfWSxSqb",
                    multisigOpAccountAddress: "4mf7Eo633trwbtrMZu7NTjvYaQZdAiVPUj8HyCdkGQ7u",
                    walletAddress: "FpyUo7gVxzB3mPVSkcHNdzdo1T6tNHvkzUvFajw2PwkG",
                    nonceAccountAddresses: nonceAccountAddresses
                ))
        )
    }
    
    func getAddDAppBookEntry(nonceAccountAddresses: [String]) -> SolanaApprovalRequestType {
        return .dAppBookUpdate(
            DAppBookUpdate(
                entriesToAdd: [
                    SlotDAppInfo(
                        slotId: 0,
                        value: SolanaDApp(address: "GNGhSWWVNhXAy4fQgfAoQejJpGAxVaE4bdJjdb6iXRjK", name: "DApp", logo: "icon")
                    )
                ],
                entriesToRemove: [],
                signingData: SolanaSigningData(
                    feePayer: "FM36ah2bH8nQWJNPCRzu7R69gE5o6UhujqJFtDpWN5as",
                    walletProgramId: "3Nh3QsaXKbTbLM1BLsD4dhT4zeHTPaVbZX3eN3Yg1G2w",
                    multisigOpAccountAddress: "Hn2CJuYyyB2H3wwmdHPy1Aun2Jkye3MCSVajzUvw55A9",
                    walletAddress: "Re4dLGch8a1G98PeRtpHa5ApS6Gnik444CqB5BQ8rY1",
                    nonceAccountAddresses: nonceAccountAddresses
                ))
        )
    }
    
    func getBalanceAccountSettingsUpdate(nonceAccountAddresses: [String]) -> SolanaApprovalRequestType {
        return .balanceAccountSettingsUpdate(
            BalanceAccountSettingsUpdate(
                accountInfo: AccountInfo(
                    name: "Account 1",
                    identifier: "b645a5d9-227f-4a9f-9331-52af64bf1989",
                    accountType: AccountType.BalanceAccount,
                    address: "DcvZ2k6ygvvu2Z5ihrSxRZL7bHJ38gPRgpCie8GzztTP"
                ),
                whitelistEnabled: BooleanSetting.On,
                dappsEnabled: nil,
                signingData: SolanaSigningData(
                    feePayer: "FM36ah2bH8nQWJNPCRzu7R69gE5o6UhujqJFtDpWN5as",
                    walletProgramId: "7kNPVcK2cpyaZsLsqmhZbjcbt433vYUckH1PM5gZeJ1L",
                    multisigOpAccountAddress: "GM2yp6wzBijkziNSDAXoDsuJ2e76VTLgqTfikh5r9BfD",
                    walletAddress: "4XaqL4MtTUDrncTGBqvTC9ketf8WVqrUocDkYhKAnDju",
                    nonceAccountAddresses: nonceAccountAddresses
                ))
        )
    }
    
    func getRemoveDAppBookEntry(nonceAccountAddresses: [String]) -> SolanaApprovalRequestType {
        return .dAppBookUpdate(
            DAppBookUpdate(
                entriesToAdd: [],
                entriesToRemove: [
                    SlotDAppInfo(
                        slotId: 0,
                        value: SolanaDApp(address: "GNGhSWWVNhXAy4fQgfAoQejJpGAxVaE4bdJjdb6iXRjK", name: "DApp", logo: "icon")
                    )
                ],
                signingData: SolanaSigningData(
                    feePayer: "FM36ah2bH8nQWJNPCRzu7R69gE5o6UhujqJFtDpWN5as",
                    walletProgramId: "3Nh3QsaXKbTbLM1BLsD4dhT4zeHTPaVbZX3eN3Yg1G2w",
                    multisigOpAccountAddress: "9CfoFci2agjCJ7bWqfgKEFSAc5zB6UR63MrK61nRaJzm",
                    walletAddress: "Re4dLGch8a1G98PeRtpHa5ApS6Gnik444CqB5BQ8rY1",
                    nonceAccountAddresses: nonceAccountAddresses
                ))
        )
    }
    
    func getWalletConfigPolicyUpdate(nonceAccountAddresses: [String]) -> SolanaApprovalRequestType {
        return .walletConfigPolicyUpdate(
            WalletConfigPolicyUpdate(
                approvalPolicy: ApprovalPolicy(
                    approvalsRequired: 3,
                    approvalTimeout: 18000000,
                    approvers: [
                        SlotSignerInfo(
                            slotId: 0,
                            value: SignerInfo(publicKey: "5zpDzYujD8xnZ5B9m93qHCGMSeLDb7eAKCo4kWha7knV", name: "User 1", email: "authorized1@org1")
                        ),
                        SlotSignerInfo(
                            slotId: 1,
                            value: SignerInfo(publicKey: "3tSshpPL1WyNR7qDfxPffinndQmgfvTGoZc3PgL65Z9o", name: "User 2", email: "user2@org1")
                        ),
                        SlotSignerInfo(
                            slotId: 2,
                            value: SignerInfo(publicKey: "5rt9dFozMbpPf2mMgiMuu2f4CxQa3pWS1Exo9wHPbwJK", name: "User 3", email: "user3@org1")
                        )
                    ]),
                signingData: SolanaSigningData(
                    feePayer: "FM36ah2bH8nQWJNPCRzu7R69gE5o6UhujqJFtDpWN5as",
                    walletProgramId: "5kx1BNgMpBbEfrrzfqZrmW8xfqpdbC8b34TkwGbXg42r",
                    multisigOpAccountAddress: "F6iUTdJDE4vnTgBanCtBgtoNHag57Uaut82xATGVVps3",
                    walletAddress: "hBVqSAZ3Z7dSrWXoQdKJGttgHVrWa3qzdeHpiX6WKk3",
                    nonceAccountAddresses: nonceAccountAddresses
                ))
        )
    }
    
    func getBalanceAccountPolicyUpdate(nonceAccountAddresses: [String]) -> SolanaApprovalRequestType {
        return .balanceAccountPolicyUpdate(
            BalanceAccountPolicyUpdate(
                accountInfo: AccountInfo(
                    name: "Account 1",
                    identifier: "1ac4a7fc-d2f8-4c32-8707-7496ee958933",
                    accountType: AccountType.BalanceAccount,
                    address: "5743aqK2n9xnTSmFcbzTmfpdtcNeWdJsCxTxrCcNXUFH"
                ),
                approvalPolicy: ApprovalPolicy(
                    approvalsRequired: 2,
                    approvalTimeout: 3600000,
                    approvers: [
                        SlotSignerInfo(
                            slotId: 0,
                            value: SignerInfo(publicKey: "4q8ApWsB3rSW2HPFwc1aWmGgcBMfj7tSKBbb5sBGAB6h", name: "User 1", email: "authorized1@org1")
                        ),
                        SlotSignerInfo(
                            slotId: 1,
                            value: SignerInfo(publicKey: "CDrdR8xX8t83eXxB2ESuHp9AxkiJkUuKnD98zyDfMtrG", name: "User 2", email: "user2@org1")
                        ),
                    ]
                ),
                signingData: SolanaSigningData(
                    feePayer: "FM36ah2bH8nQWJNPCRzu7R69gE5o6UhujqJFtDpWN5as",
                    walletProgramId: "8pPAcjFSByreFRnRm5YyAdBP2LfiNnWBtBzHtRDcJpUA",
                    multisigOpAccountAddress: "DbdTEwihgEYJYAgXBKEqQGknGyHsRnxE5coeZaVS4T9y",
                    walletAddress: "ECzeaMTMBXYXXfVM53n5iPepf8749QUqEzjW8jxefGhh",
                    nonceAccountAddresses: nonceAccountAddresses
                ))
        )
    }
    
    func getBalanceAccountNameUpdate(nonceAccountAddresses: [String]) -> SolanaApprovalRequestType {
        return .balanceAccountNameUpdate(
            BalanceAccountNameUpdate(
                accountInfo: AccountInfo(
                    name: "Account 1",
                    identifier: "b645a5d9-227f-4a9f-9331-52af64bf1989",
                    accountType: AccountType.BalanceAccount,
                    address: "DcvZ2k6ygvvu2Z5ihrSxRZL7bHJ38gPRgpCie8GzztTP"
                ),
                newAccountName: "New Name",
                signingData: SolanaSigningData(
                    feePayer: "FM36ah2bH8nQWJNPCRzu7R69gE5o6UhujqJFtDpWN5as",
                    walletProgramId: "7kNPVcK2cpyaZsLsqmhZbjcbt433vYUckH1PM5gZeJ1L",
                    multisigOpAccountAddress: "7DY87mHHiSSyxFBbhCYbTpQE5M4Jk9Z9hymJ7UzL3sPm",
                    walletAddress: "4XaqL4MtTUDrncTGBqvTC9ketf8WVqrUocDkYhKAnDju",
                    nonceAccountAddresses: nonceAccountAddresses
                ))
        )
    }
    
    func getSPLTokenAccountCreation(nonceAccountAddresses: [String]) -> SolanaApprovalRequestType {
        return .splTokenAccountCreation(
            SPLTokenAccountCreation(
                payerBalanceAccount: AccountInfo(
                    name: "Account 1",
                    identifier: "80f3c1de-947d-402d-b34f-899286410b57",
                    accountType: AccountType.BalanceAccount,
                    address: "C4xpbnRNRZr4amKCZaTfguHT72BqvqZ6p9kUnaGVxidi"
                ),
                balanceAccounts: [AccountInfo(
                    name: "Account 1",
                    identifier: "80f3c1de-947d-402d-b34f-899286410b57",
                    accountType: AccountType.BalanceAccount,
                    address: "C4xpbnRNRZr4amKCZaTfguHT72BqvqZ6p9kUnaGVxidi"
                )],
                tokenSymbolInfo: SymbolInfo(
                    symbol: "wSOL",
                    symbolDescription: "Wrapped SOL",
                    tokenMintAddress: "So11111111111111111111111111111111111111112"
                ),
                signingData: SolanaSigningData(
                    feePayer: "FM36ah2bH8nQWJNPCRzu7R69gE5o6UhujqJFtDpWN5as",
                    walletProgramId: "8pPAcjFSByreFRnRm5YyAdBP2LfiNnWBtBzHtRDcJpUA",
                    multisigOpAccountAddress: "SLnWXM1QTraLWFhCm7JxDZk11PBE5Gu524ASzAC6YjW",
                    walletAddress: "ECzeaMTMBXYXXfVM53n5iPepf8749QUqEzjW8jxefGhh",
                    nonceAccountAddresses: nonceAccountAddresses
                ))
        )
    }

    func getDAppTransactionRequest(nonceAccountAddresses: [String]) -> SolanaApprovalRequestType {
        return .dAppTransactionRequest(
            DAppTransactionRequest(
                account: AccountInfo(
                    name: "Account 1",
                    identifier: "6689604c-452c-4c35-9ab9-f7add6c539a5",
                    accountType: AccountType.BalanceAccount,
                    address: "6zmSor8Y9CXjFExGPZsJA1wk1utAJeRw6NH9a1w2zymX"
                ),
                dappInfo: SolanaDApp(
                    address: "5zR1qXBiPwDX4wnhusoFbzExL2URtD3cjjpJqyMXDZiz",
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
                                    SolanaAccountMeta(address: "6zmSor8Y9CXjFExGPZsJA1wk1utAJeRw6NH9a1w2zymX", signer: true, writable: true),
                                    SolanaAccountMeta(address: "74FrjocsXjzBzL92efmDBLKczVw7UFzQznCe76grKdeh", signer: false, writable: true),
                                    SolanaAccountMeta(address: "6zmSor8Y9CXjFExGPZsJA1wk1utAJeRw6NH9a1w2zymX", signer: true, writable: true),
                                    SolanaAccountMeta(address: "EQQKpcUbk6M5ikbK6SjezzMWUBbJB9qWtpEvw4BwuexT", signer: false, writable: false),
                                    SolanaAccountMeta(address: "11111111111111111111111111111111", signer: false, writable: false),
                                    SolanaAccountMeta(address: "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA", signer: false, writable: false),
                                    SolanaAccountMeta(address: "SysvarRent111111111111111111111111111111111", signer: false, writable: false),
                                ],
                                data: "AQIDrA=="
                            )
                        ]
                    )
                ],
                signingData: SolanaSigningData(
                    feePayer: "FM36ah2bH8nQWJNPCRzu7R69gE5o6UhujqJFtDpWN5as",
                    walletProgramId: "DafeuJ6v1Mv1cvEVU6EnH2uomCP8nvj9EbKHgXGxGChy",
                    multisigOpAccountAddress: "11111111111111111111111111111111",
                    walletAddress: "6Vie7d1hd84JnQVAyZW5V5EkTfVTF1Gap2a5mtwMqobF",
                    nonceAccountAddresses: nonceAccountAddresses
                )
            )
        )
    }
    
    func getLoginApproval(_ jwtToken: String) -> SolanaApprovalRequestType {
        return .loginApproval(LoginApproval(jwtToken: jwtToken))
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
