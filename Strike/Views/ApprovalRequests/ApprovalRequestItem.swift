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
                WithdrawalRow(requestType: request.requestType, withdrawal: withdrawal)
            } detail: {
                WithdrawalDetails(request: request, withdrawal: withdrawal)
            }
        case .conversionRequest(let conversion):
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                ConversionRow(requestType: request.requestType, conversion: conversion)
            } detail: {
                ConversionDetails(request: request, conversion: conversion)
            }
        case .signersUpdate(let signersUpdate):
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                SignerUpdateRow(requestType: request.requestType, signersUpdate: signersUpdate)
            } detail: {
                SignerUpdateDetails(request: request, signersUpdate: signersUpdate)
            }
        case .balanceAccountCreation(let accountCreation):
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                AccountCreationRow(requestType: request.requestType, accountCreation: accountCreation)
            } detail: {
                AccountCreationDetails(request: request, accountCreation: accountCreation)
            }
        case .dAppTransactionRequest(let dAppTransactionRequest):
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                DAppTransactionRow(requestType: request.requestType, transactionRequest: dAppTransactionRequest)
            } detail: {
                DAppTransactionDetails(request: request, transactionRequest: dAppTransactionRequest)
            }
        case .balanceAccountNameUpdate(let balanceAccountNameUpdate): // 3
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                BalanceAccountNameRow(requestType: request.requestType, update: balanceAccountNameUpdate)
            } detail: {
                BalanceAccountNameDetails(request: request, update: balanceAccountNameUpdate)
            }
        case .balanceAccountPolicyUpdate(let balanceAccountPolicyUpdate): // 2
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                BalanceAccountPolicyRow(requestType: request.requestType, update: balanceAccountPolicyUpdate)
            } detail: {
                BalanceAccountPolicyDetails(request: request, update: balanceAccountPolicyUpdate, user: user)
            }
        case .balanceAccountSettingsUpdate(let balanceAccountSettingsUpdate): // 5
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                BalanceAccountSettingsRow(requestType: request.requestType, update: balanceAccountSettingsUpdate)
            } detail: {
                BalanceAccountSettingsDetails(request: request, update: balanceAccountSettingsUpdate, user: user)
            }
        case .addressBookUpdate(let addressBookUpdate): // 4 - remove whitelist
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                AddressBookUpdateRow(requestType: request.requestType, update: addressBookUpdate)
            } detail: {
                AddressBookUpdateDetails(request: request, update: addressBookUpdate)
            }
        case .dAppBookUpdate(let dAppBookUpdate):
            UnknownRequestRow(request: request, timerPublisher: timerPublisher)
        case .walletConfigPolicyUpdate(let walletConfigPolicyUpdate): // 1
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                WalletConfigPolicyRow(requestType: request.requestType, update: walletConfigPolicyUpdate)
            } detail: {
                WalletConfigPolicyDetails(request: request, update: walletConfigPolicyUpdate)
            }
        case .wrapConversionRequest(let wrapConversionRequest):
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                WrapConversionRow(requestType: request.requestType, conversion: wrapConversionRequest)
            } detail: {
                WrapConversionDetail(request: request, conversion: wrapConversionRequest)
            }
        case .balanceAccountAddressWhitelistUpdate(let balanceAccountAddressWhitelistUpdate):
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                BalanceAccountWhitelistRow(requestType: request.requestType, update: balanceAccountAddressWhitelistUpdate)
            } detail: {
                BalanceAccountWhitelistDetails(request: request, update: balanceAccountAddressWhitelistUpdate, user: user)
            }
        case .loginApproval(let login):
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                LoginRow(requestType: request.requestType, login: login)
            } detail: {
                LoginDetails(requestType: request.requestType, login: login)
            }
        case .acceptVaultInvitation(let acceptVaultInvitation):
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher, onStatusChange: onStatusChange) {
                AcceptVaultInvitationRow(requestType: request.requestType, acceptVaultInvitation: acceptVaultInvitation)
            } detail: {
                AcceptVaultInvitationDetails(requestType: request.requestType, acceptVaultInvitation: acceptVaultInvitation)
            }
        }
    }
}
