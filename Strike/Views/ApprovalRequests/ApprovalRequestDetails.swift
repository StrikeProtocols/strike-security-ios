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
    @State private var isComposingMail = false
    @State private var timeRemaining: DateComponents = DateComponents()

    var user: StrikeApi.User
    var request: WalletApprovalRequest
    var timerPublisher: Publishers.Autoconnect<Timer.TimerPublisher>
    var onStatusChange: (() -> Void)?
    @ViewBuilder var content: () -> Content
    var statusTitle: String {
        switch request.requestType {
        case .acceptVaultInvitation:
            return ""
        default:
            return "STATUS"
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 15) {
                    VStack(alignment: .center, spacing: 0) {
                        Text(request.requestType.header)
                            .font(.title)
                            .bold()
                            .lineLimit(1)
                            .allowsTightening(true)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.25)
                            .foregroundColor(Color.white)
                            .padding(.top, 20)

                        if let header2 = request.requestType.header2 {
                            Text(header2)
                                .font(.title2)
                                .lineLimit(1)
                                .allowsTightening(true)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.25)
                                .foregroundColor(Color.white.opacity(0.8))
                                .padding(.top, 5)
                        }
                        
                        if let subHeader = request.requestType.subHeader {
                            Text(subHeader)
                                .font(.caption)
                                .foregroundColor(Color.white.opacity(0.5))
                                .padding(.top, 5)
                        }
                    }
                    .padding(.bottom, 10)

                    content()

                    FactsSection(title: statusTitle) {
                        if let vaultName = request.vaultName {
                            Fact("Vault Name", vaultName)
                        }

                        switch request.requestType {
                        case .acceptVaultInvitation:
                            Fact("Invited By", request.submitterName)
                            Fact("Invited By Email", request.submitterEmail) {
                                isComposingMail = true
                            }
                        default:
                            Fact("Initiated By", request.submitterEmail) {
                                isComposingMail = true
                            }
                            Fact("Approvals Received", "\(request.numberOfApprovalsReceived) of \(request.numberOfDispositionsRequired)")

                            Fact("Denials Received", "\(request.numberOfDeniesReceived) of \(request.numberOfDispositionsRequired)")
                        }
                        
                        
                        if let expireDate = request.expireDate {
                            if expireDate <= Date() {
                                Fact("Expired", "")
                            } else {
                                Fact("Expires In", formattedCountdown)
                            }
                        }
                    }
                    .onReceive(timerPublisher) { _ in
                        updateTimeRemaining()
                    }
                    .onAppear(perform: updateTimeRemaining)
                }
            }

            VStack(alignment: .center, spacing: 15) {
                Button {
                    switch request.requestType {
                    case .loginApproval:
                        ignore()
                    default:
                        alert = .ignoreConfirmation
                    }
                } label: {
                    Text(request.details.ignoreCaption.capitalized)
                        .loadingIndicator(when: action == .ignoring)
                }
                .buttonStyle(DestructiveButtonStyle())

                Button {
                    switch request.requestType {
                    case .loginApproval:
                        approve()
                    default:
                        alert = .approveConfirmation
                    }
                } label: {
                    Text(request.details.approveButtonCaption)
                        .loadingIndicator(when: action == .approving)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding()
            .background(
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundColor(.black)
                    .shadow(color: .Strike.gray, radius: 0, x: 0, y: -1)
            )
        }
        .background(Color.Strike.primaryBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .disabled(action != .none)
        .alert(item: $alert) { alertType in
            switch alertType {
            case .approveConfirmation:
                return Alert(
                    title: Text("Are you sure?"),
                    message: Text("You are about to approve the following request:\n \(request.requestType.header)"),
                    primaryButton: Alert.Button.default(Text("Confirm"), action: approve),
                    secondaryButton: Alert.Button.cancel(Text("Cancel"))
                )
            case .ignoreConfirmation:
                return Alert(
                    title: Text("Are you sure?"),
                    message: Text("You are about to \(request.details.ignoreCaption) the following request:\n \(request.requestType.header)"),
                    primaryButton: Alert.Button.default(Text("Confirm"), action: ignore),
                    secondaryButton: Alert.Button.cancel(Text("Cancel"))
                )
            case .ignoreError(let error):
                return Alert.withDismissButton(title: Text("Error"), message: Text(ignoreMessage(for: error)))
            case .approveError(let error):
                return Alert.withDismissButton(title: Text("Error"), message: Text(ignoreMessage(for: error)))
            }
        }
        .navigationTitle("Details")
        .sheet(isPresented: $isComposingMail) {
            ComposeMail(
                subject: "Strike Approval Request: \(request.id) on \(request.submitDate)",
                toRecipients: [request.submitterEmail],
                completion: nil
            )
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

    private func updateTimeRemaining() {
        if let expireDate = request.expireDate {
            timeRemaining = Calendar.current.dateComponents([.hour, .minute, .second], from: Date(), to: expireDate)
        }
    }

    private var formattedCountdown: String {
        DateComponentsFormatter.positionalFormatter.string(for: timeRemaining) ?? ""
    }

    private func approve() {
        action = .approving

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

        strikeApi.provider.requestWithNonces(
            accountAddresses: request.requestType.nonceAccountAddresses,
            accountAddressesSlot: request.requestType.nonceAccountAddressesSlot
        ) { nonces in
            switch request.details {
            case .approval(let requestType):
                return .registerApprovalDisposition(
                    StrikeApi.ApprovalDispositionRequest(
                        disposition: .Deny,
                        requestID: request.id,
                        requestType: requestType,
                        nonces: nonces,
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
                        nonces: nonces,
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

extension SolanaApprovalRequestDetails {
    var approveButtonCaption: String {
        switch self {
        case .multisigOpInitiation(let initiation, _) where !initiation.initiatorIsApprover:
            return "Initiate"
        default:
            return "Approve"
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
