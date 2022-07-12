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
            return "Send \(request.symbolAndAmountInfo.formattedAmount) \(request.symbolAndAmountInfo.symbolInfo.symbol)"
        case .unknown:
            return "Unknown"
        case .conversionRequest(let request):
            return "Convert \(request.symbolAndAmountInfo.formattedAmount) \(request.symbolAndAmountInfo.symbolInfo.symbol)"
        case .wrapConversionRequest(let request):
            return "Swap \(request.symbolAndAmountInfo.formattedAmount) \(request.symbolAndAmountInfo.symbolInfo.symbol)"
        case .signersUpdate(let update) where update.slotUpdateType == .Clear:
            return "Remove User"
        case .signersUpdate:
            return "Add User"
        case .balanceAccountCreation(let accountCreation) where accountCreation.accountInfo.accountType == .BalanceAccount:
            return "Add Wallet"
        case .balanceAccountCreation:
            return "Add Wallet"
        case .balanceAccountNameUpdate:
            return "Rename"
        case .balanceAccountPolicyUpdate:
            return "Update Transfer Approvals"
        case .balanceAccountSettingsUpdate(let update) where update.change == .dappsEnabled(false):
            return "Disable dApp Access"
        case .balanceAccountSettingsUpdate(let update) where update.change == .dappsEnabled(true):
            return "Enable dApp Access"
        case .balanceAccountSettingsUpdate(let update) where update.change == .whitelistEnabled(false):
            return "Disable Whitelist"
        case .balanceAccountSettingsUpdate(let update):
            return "Enable Whitelist"
        case .balanceAccountAddressWhitelistUpdate(let update):
            return "Edit Whitelist Addresses"
        case .addressBookUpdate(let update) where update.change == .add:
            return "Add Address"
        case .addressBookUpdate(let update):
            return "Remove Address"
        case .dAppBookUpdate:
            return "Replace dApp Book"
        case .walletConfigPolicyUpdate:
            return "Update Administration Policy"
        case .dAppTransactionRequest:
            return "Execute dApp Transaction"
        case .loginApproval:
            return "Log In"
        case .acceptVaultInvitation:
            return "Accept Vault Invitation"
        }
    }
    
    var header2: String? {
        switch self {
        case .balanceAccountSettingsUpdate(let update):
            return update.account.name.walletName()
        case .balanceAccountPolicyUpdate(let update):
            return update.accountInfo.name.walletName()
        case .balanceAccountAddressWhitelistUpdate(let update):
            return update.accountInfo.name.walletName()
        case .balanceAccountNameUpdate(let update):
            return "\(update.accountInfo.name.walletName()) → \(update.newAccountName.walletName())"
        default:
            return nil
        }
    }

    var subHeader: String? {
        switch self {
        case .withdrawalRequest(let request):
            return request.symbolAndAmountInfo.formattedUSDEquivalent.flatMap {
                "\($0) USD equivalent"
            }
        case .conversionRequest(let request):
            return request.symbolAndAmountInfo.formattedUSDEquivalent.flatMap {
                "\($0) USD equivalent"
            }
        case .wrapConversionRequest(let request):
            return request.symbolAndAmountInfo.formattedUSDEquivalent.flatMap {
                "\($0) USD equivalent"
            }
        default:
            return nil
        }
    }

    var titleDescription: String {
        switch self {
        case .withdrawalRequest,
             .conversionRequest,
             .wrapConversionRequest,
             .balanceAccountCreation,
             .balanceAccountNameUpdate,
             .balanceAccountPolicyUpdate,
             .balanceAccountSettingsUpdate,
             .balanceAccountAddressWhitelistUpdate,
             .dAppTransactionRequest:
            return "Wallet Change"
        case .signersUpdate,
             .acceptVaultInvitation:
            return "User Change"
        case .addressBookUpdate,
             .dAppBookUpdate:
            return "Address Book Change"
        case .walletConfigPolicyUpdate:
            return "Administration Change"
        case .loginApproval:
            return "Authentication"
        case .unknown:
            return "Unknown"
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
        case .dAppTransactionRequest:
            return Image("conversion")
        case .loginApproval:
            return Image("person.crop.circle.badge.questionmark")
        case .acceptVaultInvitation:
            return Image(systemName: "iphone")
        }
    }
}
