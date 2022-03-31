//
//  ApprovalRequestDetails.swift
//  Strike
//
//  Created by Ata Namvari on 2021-04-19.
//

import Foundation
import SwiftUI
import CryptoKit
import Combine

struct ApprovalRequestDetails<Content>: View where Content : View {
    @Environment(\.strikeApi) var strikeApi

    @State private var action: Action = .none
    @State private var alert: AlertType? = nil

    var user: StrikeApi.User
    var request: WalletApprovalRequest
    var timerPublisher: Publishers.Autoconnect<Timer.TimerPublisher>
    var onStatusChange: (() -> Void)?
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            Countdown(date: request.expireDate, prefix: "Expires in ", suffix: "", timerPublisher: timerPublisher)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity)
                .padding(5)
                .background(request.expireDate <= Date() ? Color.Strike.red : Color.white.opacity(0.05))

            ScrollView(.vertical) {
                content()

                VStack(alignment: .center, spacing: 15) {
                    Button {
                        alert = .ignoreConfirmation
                    } label: {
                        Text(request.details.ignoreCaption.capitalized)
                            .loadingIndicator(when: action == .ignoring)
                    }
                    .buttonStyle(DestructiveButtonStyle())

                    Button {
                        alert = .approveConfirmation
                    } label: {
                        Text("Approve")
                            .loadingIndicator(when: action == .approving)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding()
            }
        }
        .background(Color.Strike.primaryBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .disabled(action != .none)
        .alert(item: $alert) { alertType in
            switch alertType {
            case .approveConfirmation:
                return Alert(
                    title: Text("Are you sure?"),
                    message: Text("You are about to approve \(request.requestType.summaryDescription)"),
                    primaryButton: Alert.Button.default(Text("Confirm"), action: approve),
                    secondaryButton: Alert.Button.cancel(Text("Cancel"))
                )
            case .ignoreConfirmation:
                return Alert(
                    title: Text("Are you sure?"),
                    message: Text("You are about to \(request.details.ignoreCaption) \(request.requestType.summaryDescription)"),
                    primaryButton: Alert.Button.default(Text("Confirm"), action: ignore),
                    secondaryButton: Alert.Button.cancel(Text("Cancel"))
                )
            case .ignoreError(let error):
                return Alert.withDismissButton(title: Text("Error"), message: Text(ignoreMessage(for: error)))
            case .approveError(let error):
                return Alert.withDismissButton(title: Text("Error"), message: Text(ignoreMessage(for: error)))
            }
        }
    }

    private func ignoreMessage(for error: Error) -> String {
        switch error {
        case BiometryError.required:
            return "Please enable biometry in settings to continue"
        default:
            return "Unable to \(request.details.ignoreCaption) request. Please try again"
        }
    }

    private func approveMessage(for error: Error) -> String {
        switch error {
        case BiometryError.required:
            return "Please enable biometry in settings to continue"
        default:
            return "Unable to approve request. Please try again"
        }
    }

    private func approve() {
        action = .approving

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
            action = .none

            switch result {
            case .failure(let error):
                print(error)
                alert = .approveError(error)
            case .success:
                onStatusChange?()
            }
        }
    }

    private func ignore() {
        action = .ignoring

        strikeApi.provider.requestWithRecentBlockhash { blockhash in
            switch request.details {
            case .approval(let requestType):
                return .registerApprovalDisposition(
                    StrikeApi.ApprovalDispositionRequest(
                        disposition: .Deny,
                        requestID: request.id,
                        requestType: requestType,
                        blockhash: blockhash,
                        email: user.loginName
                    )
                )
            case .multisigOpInitiation(let initiation, let requestType):
                return .initiateRequest(
                    StrikeApi.InitiationRequest(
                        disposition: .Deny,
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
            action = .none

            switch result {
            case .failure(let error):
                print(error)
                alert = .ignoreError(error)
            case .success:
                onStatusChange?()
            }
        }
    }
}

extension ApprovalRequestDetails {
    enum Action: Int, Equatable {
        case none
        case approving
        case ignoring
    }
}

extension ApprovalRequestDetails {
    enum AlertType: Identifiable {
        case approveConfirmation
        case ignoreConfirmation
        case ignoreError(Error)
        case approveError(Error)

        var id: String {
            switch self {
            case .approveConfirmation:
                return "approve"
            case .ignoreConfirmation:
                return "deny"
            case .ignoreError(let error),
                 .approveError(let error):
                return error.localizedDescription
            }
        }
    }
}

extension SolanaApprovalRequestDetails {
    var ignoreCaption: String {
        switch self {
        case .multisigOpInitiation:
            return "cancel"
        case .approval:
            return "deny"
        }
    }
}

#if DEBUG
struct ApprovalRequestDetails_Previews: PreviewProvider {
    static var previews: some View {
        let timerPublisher = Timer.TimerPublisher(interval: 1, runLoop: .current, mode: .default).autoconnect()

        NavigationView {
            ApprovalRequestDetails(user: .sample, request: .sample, timerPublisher: timerPublisher) {
                WithdrawalDetails(request: .sample, withdrawal: .sample)
            }
        }
    }
}
#endif
