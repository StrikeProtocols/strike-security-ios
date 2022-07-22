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
    
    var titleVaultName: String? {
        switch request.requestType {
        case .acceptVaultInvitation:
            return nil
        default:
            return request.vaultName?.toVaultName()
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                if let titleVaultName = titleVaultName {
                    Text(titleVaultName)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .allowsTightening(true)
                        .font(.subheadline)
                        .foregroundColor(Color.white)
                }
                Spacer()
                if let expireDate = request.expireDate {
                    Countdown(date: expireDate, timerPublisher: timerPublisher)
                        .font(.subheadline)
                        .foregroundColor(Color.white.opacity(0.5))
                }
            }
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            .background(Color.Strike.thirdBackground /**/)

            row()

            Divider()

            HStack(spacing: 0) {
                Button {
                    switch request.requestType {
                    case .loginApproval:
                        approve()
                    default:
                        alert = .confirmation
                    }
                } label: {
                    Text(request.details.approveButtonCaption)
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
                            message: Text("You are about to approve the following request:\n \(request.requestType.header)"),
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

        strikeApi.provider.requestWithNonces(
            accountAddresses: request.requestType.nonceAccountAddresses,
            accountAddressesSlot: request.requestType.nonceAccountAddressesSlot
        ) { nonces in
            switch request.details {
            case .approval(let requestType):
                return .registerApprovalDisposition(
                    StrikeApi.ApprovalDispositionRequest(
                        disposition: .Approve,
                        requestID: request.id,
                        requestType: requestType,
                        nonces: nonces,
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
                        nonces: nonces,
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
    var expireDate: Date? {
        approvalTimeoutInSeconds != nil ? submitDate.addingTimeInterval(TimeInterval(approvalTimeoutInSeconds!)) : nil
    }
}

#if DEBUG
struct ApprovalRequestRow_Preivews: PreviewProvider {
    static var previews: some View {
        let timerPublisher = Timer.TimerPublisher(interval: 1, runLoop: .current, mode: .default).autoconnect()

        ApprovalRequestRow(user: .sample, request: .sample, timerPublisher: timerPublisher) {
            WithdrawalRow(requestType: .withdrawalRequest(.sample), withdrawal: .sample)
        } detail: {
            WithdrawalDetails(request: .sample, withdrawal: .sample)
        }
    }
}
#endif
