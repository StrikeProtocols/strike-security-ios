//
//  ApprovalRequestItem.swift
//  Strike
//
//  Created by Ata Namvari on 2021-09-01.
//

import Foundation
import SwiftUI
import Combine
import Alamofire


struct ApprovalRequestItem: View {
    var user: StrikeApi.User
    var request: WalletApprovalRequest
    var onStatusChange: (() -> Void)?
    var timerPublisher: Publishers.Autoconnect<Timer.TimerPublisher>

    var body: some View {
        switch request.requestType {
        case .unknown:
            UnknownRequestRow(request: request, timerPublisher: timerPublisher)
        case .withdrawalRequest(let withdrawal):
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                WithdrawalRow(withdrawal: withdrawal)
            } detail: {
                WithdrawalDetails(request: request, withdrawal: withdrawal)
            }
        case .conversionRequest(let conversion):
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                ConversionRow(conversion: conversion)
            } detail: {
                ConversionDetails(request: request, conversion: conversion)
            }
        case .signersUpdate(let signersUpdate):
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                SignerUpdateRow(signersUpdate: signersUpdate)
            } detail: {
                SignerUpdateDetails(request: request, signersUpdate: signersUpdate)
            }
        case .balanceAccountCreation(let accountCreation):
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                AccountCreationRow(accountCreation: accountCreation)
            } detail: {
                AccountCreationDetails(request: request, accountCreation: accountCreation)
            }
        case .dAppTransactionRequest(let dAppTransactionRequest):
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                DAppTransactionRow(transactionRequest: dAppTransactionRequest)
            } detail: {
                DAppTransactionDetails(request: request, transactionRequest: dAppTransactionRequest)
            }
        case .balanceAccountNameUpdate(let balanceAccountNameUpdate): // 3
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                BalanceAccountNameRow(update: balanceAccountNameUpdate)
            } detail: {
                BalanceAccountNameDetails(request: request, update: balanceAccountNameUpdate)
            }
        case .balanceAccountPolicyUpdate(let balanceAccountPolicyUpdate): // 2
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                BalanceAccountPolicyRow(update: balanceAccountPolicyUpdate)
            } detail: {
                BalanceAccountPolicyDetails(request: request, update: balanceAccountPolicyUpdate, user: user)
            }
        case .balanceAccountSettingsUpdate(let balanceAccountSettingsUpdate): // 5
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                BalanceAccountSettingsRow(update: balanceAccountSettingsUpdate)
            } detail: {
                BalanceAccountSettingsDetails(request: request, update: balanceAccountSettingsUpdate, user: user)
            }
        case .addressBookUpdate(let addressBookUpdate): // 4 - remove whitelist
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                AddressBookUpdateRow(update: addressBookUpdate)
            } detail: {
                AddressBookUpdateDetails(request: request, update: addressBookUpdate)
            }
        case .dAppBookUpdate(let dAppBookUpdate):
            UnknownRequestRow(request: request, timerPublisher: timerPublisher)
        case .walletConfigPolicyUpdate(let walletConfigPolicyUpdate): // 1
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                WalletConfigPolicyRow(update: walletConfigPolicyUpdate)
            } detail: {
                WalletConfigPolicyDetails(request: request, update: walletConfigPolicyUpdate)
            }
        case .splTokenAccountCreation(let splTokenAccountCreation): // 6
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                SPLTokenAccountCreationRow(creation: splTokenAccountCreation)
            } detail: {
                SPLTokenAccountCreationDetails(request: request, creation: splTokenAccountCreation, user: user)
            }
        case .wrapConversionRequest(let wrapConversionRequest):
            UnknownRequestRow(request: request, timerPublisher: timerPublisher)
        case .loginApproval:
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                LoginRow()
            } detail: {
                LoginDetails()
            }
        }
    }
}
