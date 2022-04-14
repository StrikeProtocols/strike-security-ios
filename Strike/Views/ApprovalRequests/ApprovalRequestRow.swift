//
//  ApprovalRequestRow.swift
//  Strike
//
//  Created by Ata Namvari on 2021-04-19.
//

import Foundation
import SwiftUI
import CryptoKit
import Combine

struct ApprovalRequestRow<Row, Detail>: View where Row : View, Detail: View {
    @Environment(\.strikeApi) var strikeApi

    @State private var isLoading = false
    @State private var alert: AlertType? = nil
    @State private var navigated = false

    var user: StrikeApi.User
    var request: WalletApprovalRequest
    var timerPublisher: Publishers.Autoconnect<Timer.TimerPublisher>
    var onStatusChange: (() -> Void)?
    @ViewBuilder var row: () -> Row
    @ViewBuilder var detail: () -> Detail

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                request.requestType.icon

                Text(request.requestType.titleDescription)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .allowsTightening(true)
                    .textCase(.uppercase)
                    .font(.subheadline)
                    .foregroundColor(Color.white)
                Spacer()
                Countdown(date: request.expireDate, timerPublisher: timerPublisher)
                    .font(.subheadline)
                    .foregroundColor(Color.white.opacity(0.5))
            }
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            .background(Color.Strike.thirdBackground /**/)

            row()

            Divider()

            HStack(spacing: 0) {
                Button {
                    alert = .confirmation
                } label: {
                    Text("Approve")
                        .bold()
                        .loadingIndicator(when: isLoading)
                        .foregroundColor(Color.Strike.green)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.Strike.green))
                }
                .alert(item: $alert) { alertType in
                    switch alertType {
                    case .confirmation:
                        return Alert(
                            title: Text("Are you sure?"),
                            message: Text("You are about to approve \(request.requestType.summaryDescription)"),
                            primaryButton: Alert.Button.default(Text("Confirm"), action: approve),
                            secondaryButton: Alert.Button.cancel(Text("Cancel"))
                        )
                    case .error:
                        return Alert.withDismissButton(title: Text("Error"), message: Text("Unable to approve request. Please try again"))
                    }
                }

                Divider()

                Button {
                    navigated = true
                } label: {
                    Text("More Info...")
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(height: 45)
            .disabled(isLoading)

            NavigationLink(isActive: $navigated) {
                ApprovalRequestDetails(
                    user: user,
                    request: request,
                    timerPublisher: timerPublisher,
                    onStatusChange: onStatusChange,
                    content: detail
                )
                .environment(\.strikeApi, strikeApi)
            } label: {
                EmptyView()
            }
            .hidden()
        }
        .roundedCell(background: Color.Strike.secondaryBackground)
    }

    private func approve() {
        isLoading = true

        strikeApi.provider.requestWithRecentBlockhash { blockhash in
            switch request.details {
            case .approval(let requestType):
                return .registerApprovalDisposition(
                    StrikeApi.ApprovalDispositionRequest(
                        disposition: .Approve,
                        requestID: request.id,
                        requestType: requestType,
                        blockhash: blockhash,
                        email: user.loginName
                    )
                )
            case .multisigOpInitiation(let initiation, let requestType):
                return .initiateRequest(
                    StrikeApi.InitiationRequest(
                        disposition: .Approve,
                        requestID: request.id,
                        initiation: initiation,
                        requestType: requestType,
                        blockhash: blockhash,
                        email: user.loginName,
                        opAccountPrivateKey: Curve25519.Signing.PrivateKey(),
                        dataAccountPrivateKey: Curve25519.Signing.PrivateKey()
                    )
                )
            }
        } completion: { result in
            isLoading = false

            switch result {
            case .failure(let error):
                print(error)
                alert = .error(error)
            case .success:
                onStatusChange?()
            }
        }
    }
}

extension ApprovalRequestRow {
    enum AlertType: Identifiable {
        case confirmation
        case error(Error)

        var id: String {
            switch self {
            case .confirmation:
                return "confirmation"
            case .error(let error):
                return error.localizedDescription
            }
        }
    }
}

extension WalletApprovalRequest {
    var expireDate: Date {
        submitDate.addingTimeInterval(TimeInterval(approvalTimeoutInSeconds))
    }
}

extension SolanaApprovalRequestType {
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
            return "Balance Account Creation"
        case .balanceAccountCreation:
            return "Stake Account Creation"
        case .balanceAccountNameUpdate:
            return "Balance Account Name Update"
        case .balanceAccountPolicyUpdate:
            return "Balance Account Policy Update"
        case .balanceAccountSettingsUpdate:
            return "Balance Account Settings Update"
        case .addressBookUpdate:
            return "Address Book Update"
        case .dAppBookUpdate:
            return "dApp Book Update"
        case .walletConfigPolicyUpdate:
            return "Wallet Config Policy Update"
        case .splTokenAccountCreation:
            return "SPL Token Account Creation"
        case .dAppTransactionRequest:
            return "dApp Transaction"
        case .loginApproval:
            return "Login Approval"
        }
    }

    var summaryDescription: String {
        switch self {
        case .withdrawalRequest(let withdrawal):
            return "a transfer of \(withdrawal.symbolAndAmountInfo.formattedAmount) \(withdrawal.symbolAndAmountInfo.symbolInfo.symbol) \(withdrawal.symbolAndAmountInfo.formattedUSDEquivalent.flatMap { "(\($0) USD)" } ?? "")"
        case .unknown:
            return "an unknown approval request"
        case .conversionRequest(let conversion):
            return "a conversion of \(conversion.symbolAndAmountInfo.formattedAmount) \(conversion.symbolAndAmountInfo.symbolInfo.symbol) \(conversion.symbolAndAmountInfo.formattedUSDEquivalent.flatMap { "(\($0) USD)" } ?? "")"
        case .signersUpdate(let signersUpdate) where signersUpdate.slotUpdateType == .Clear:
            return "the removal of `\(signersUpdate.signer.value.name)`"
        case .signersUpdate(let signersUpdate):
            return "the addition of `\(signersUpdate.signer.value.name)`"
        case .balanceAccountCreation(let balanceAccountCreation):
            return "an account creation of \(balanceAccountCreation.accountInfo.name)"
        case .balanceAccountNameUpdate(let balanceAccountNameUpdate):
            return "account name change to \(balanceAccountNameUpdate.newAccountName)"
        case .balanceAccountPolicyUpdate(let balanceAccountPolicyUpdate):
            return "policy update for \(balanceAccountPolicyUpdate.accountInfo.name)"
        case .balanceAccountSettingsUpdate(let balanceAccountSettingsUpdate):
            return "settings update for \(balanceAccountSettingsUpdate.accountInfo.name)"
        case .addressBookUpdate:
            return "address book update"
        case .dAppBookUpdate:
            return "dApp book update"
        case .walletConfigPolicyUpdate:
            return "wallet config policy update"
        case .splTokenAccountCreation(let splTokenAccountCreation):
            return "SPL token account creation for \(splTokenAccountCreation.tokenSymbolInfo.symbolDescription)"
        case .wrapConversionRequest(let wrapConversion):
            return "a conversion of \(wrapConversion.symbolAndAmountInfo.formattedAmount) \(wrapConversion.symbolAndAmountInfo.symbolInfo.symbol) to \(wrapConversion.destinationSymbolInfo.symbol)"
        case .dAppTransactionRequest(let dAppTransactionRequest):
            return "a dApp transaction with \(dAppTransactionRequest.dAppInfo.name)"
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
            return Image("policy")
        }
    }
}

#if DEBUG
struct ApprovalRequestRow_Preivews: PreviewProvider {
    static var previews: some View {
        let timerPublisher = Timer.TimerPublisher(interval: 1, runLoop: .current, mode: .default).autoconnect()

        ApprovalRequestRow(user: .sample, request: .sample, timerPublisher: timerPublisher) {
            WithdrawalRow(withdrawal: .sample)
        } detail: {
            WithdrawalDetails(request: .sample, withdrawal: .sample)
        }
    }
}
#endif
