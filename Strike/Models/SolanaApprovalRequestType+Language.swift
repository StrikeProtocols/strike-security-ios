//
//  SolanaApprovalRequestType+Language.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-18.
//

import Foundation
import SwiftUI

extension SolanaApprovalRequestType {
    var header: String {
        switch self {
        case .withdrawalRequest(let request):
            return "Send \(request.symbolAndAmountInfo.symbolInfo.symbol)"
        case .unknown:
            return "Unknown"
        case .conversionRequest(let request):
            return "Convert \(request.symbolAndAmountInfo.symbolInfo.symbol)"
        case .wrapConversionRequest(let request):
            return "Convert \(request.symbolAndAmountInfo.symbolInfo.symbol)"
        case .signersUpdate(let update) where update.slotUpdateType == .Clear:
            return "Remove Signer"
        case .signersUpdate:
            return "Add Update"
        case .balanceAccountCreation(let accountCreation) where accountCreation.accountInfo.accountType == .BalanceAccount:
            return "Add Wallet"
        case .balanceAccountCreation:
            return "Add Wallet"
        case .balanceAccountNameUpdate:
            return "Rename Wallet"
        case .balanceAccountPolicyUpdate:
            return "Replace Wallet Approval Policy"
        case .balanceAccountSettingsUpdate(let update) where update.change == .dappsEnabled(false):
            return "Disable dApp Access"
        case .balanceAccountSettingsUpdate(let update) where update.change == .dappsEnabled(true):
            return "Enable dApp Access"
        case .balanceAccountSettingsUpdate(let update) where update.change == .whitelistEnabled(false):
            return "Disable Transfer Whitelist"
        case .balanceAccountSettingsUpdate:
            return "Enable Transfer Whitelist"
        case .balanceAccountAddressWhitelistUpdate:
            return "Replace Transfer Whitelist"
        case .addressBookUpdate(let update) where update.change == .add:
            return "Add Address Book Entry"
        case .addressBookUpdate:
            return "Remove Address Book Entry"
        case .dAppBookUpdate:
            return "Replace dApp Book"
        case .walletConfigPolicyUpdate:
            return "Replace Vault Approval Policy"
        case .splTokenAccountCreation:
            return "Enable SPL Token"
        case .dAppTransactionRequest:
            return "Execute dApp Transaction"
        case .loginApproval:
            return "Log In"
        }
    }

    var titleDescription: String {
        switch self {
        case .withdrawalRequest:
            return "Transfer"
        case .unknown:
            return "Unknown"
        case .conversionRequest:
            return "Conversion"
        case .wrapConversionRequest:
            return "Conversion"
        case .signersUpdate:
            return "Signers Update"
        case .balanceAccountCreation(let accountCreation) where accountCreation.accountInfo.accountType == .BalanceAccount:
            return "Wallet Creation"
        case .balanceAccountCreation:
            return "Stake Wallet Creation"
        case .balanceAccountNameUpdate:
            return "Wallet Name Update"
        case .balanceAccountPolicyUpdate:
            return "Wallet Policy Update"
        case .balanceAccountSettingsUpdate:
            return "Wallet Settings Update"
        case .balanceAccountAddressWhitelistUpdate:
            return "Replace Transfer Whitelist"
        case .addressBookUpdate:
            return "Address Book Update"
        case .dAppBookUpdate:
            return "dApp Book Update"
        case .walletConfigPolicyUpdate:
            return "Vault Config Policy Update"
        case .splTokenAccountCreation:
            return "SPL Token Account Creation"
        case .dAppTransactionRequest:
            return "dApp Transaction"
        case .loginApproval:
            return "Login Approval"
        }
    }

    var icon: Image {
        switch self {
        case .withdrawalRequest:
            return Image("transfer")
        case .unknown:
            return Image(systemName: "questionmark.circle")
        case .conversionRequest:
            return Image("conversion")
        case .wrapConversionRequest:
            return Image("conversion")
        case .signersUpdate:
            return Image(systemName: "iphone")
        case .balanceAccountCreation:
            return Image("policy")
        case .balanceAccountNameUpdate:
            return Image("policy")
        case .balanceAccountPolicyUpdate:
            return Image("policy")
        case .balanceAccountSettingsUpdate:
            return Image("policy")
        case .balanceAccountAddressWhitelistUpdate:
            return Image("policy")
        case .addressBookUpdate:
            return Image("policy")
        case .dAppBookUpdate:
            return Image("policy")
        case .walletConfigPolicyUpdate:
            return Image("policy")
        case .splTokenAccountCreation:
            return Image("policy")
        case .dAppTransactionRequest:
            return Image("conversion")
        case .loginApproval:
            return Image("person.crop.circle.badge.questionmark")
        }
    }
}
