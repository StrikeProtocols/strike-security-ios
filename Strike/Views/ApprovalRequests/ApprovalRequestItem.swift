//
//  ApprovalRequestItem.swift
//  Strike
//
//  Created by Ata Namvari on 2021-09-01.
//

import Foundation
import SwiftUI
import Combine


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
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher) {
                SignerUpdateRow(signersUpdate: signersUpdate)
            } detail: {
                SignerUpdateDetails(request: request, signersUpdate: signersUpdate)
            }
        case .balanceAccountCreation(let accountCreation):
            ApprovalRequestRow(user: user, request: request, timerPublisher: timerPublisher) {
                AccountCreationRow(accountCreation: accountCreation)
            } detail: {
                AccountCreationDetails(request: request, accountCreation: accountCreation)
            }
        case .balanceAccountNameUpdate(let balanceAccountNameUpdate):
            UnknownRequestRow(request: request, timerPublisher: timerPublisher)
        case .balanceAccountPolicyUpdate(let balanceAccountPolicyUpdate):
            UnknownRequestRow(request: request, timerPublisher: timerPublisher)
        case .balanceAccountSettingsUpdate(let balanceAccountSettingsUpdate):
            UnknownRequestRow(request: request, timerPublisher: timerPublisher)
        case .addressBookUpdate(let addressBookUpdate):
            UnknownRequestRow(request: request, timerPublisher: timerPublisher)
        case .dAppBookUpdate(let dAppBookUpdate):
            UnknownRequestRow(request: request, timerPublisher: timerPublisher)
        case .walletConfigPolicyUpdate(let walletConfigPolicyUpdate):
            UnknownRequestRow(request: request, timerPublisher: timerPublisher)
        case .splTokenAccountCreation(let splTokenAccountCreation):
            UnknownRequestRow(request: request, timerPublisher: timerPublisher)
        case .dAppTransactionRequest(let dAppTransactionRequest):
            UnknownRequestRow(request: request, timerPublisher: timerPublisher)
        case .wrapConversionRequest(let wrapConversionRequest):
            UnknownRequestRow(request: request, timerPublisher: timerPublisher)
        case .loginApproval(let loginApproval):
            UnknownRequestRow(request: request, timerPublisher: timerPublisher)
        }
    }
}
