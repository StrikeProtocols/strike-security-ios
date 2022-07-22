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
            return "Accept Invitation"
        }
    }
    
    var header2: String? {
        switch self {
        case .balanceAccountSettingsUpdate(let update):
            return update.account.name.toWalletName()
        case .balanceAccountPolicyUpdate(let update):
            return update.accountInfo.name.toWalletName()
        case .balanceAccountAddressWhitelistUpdate(let update):
            return update.accountInfo.name.toWalletName()
        case .balanceAccountNameUpdate(let update):
            return "\(update.accountInfo.name.toWalletName()) → \(update.newAccountName.toWalletName())"
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
}
