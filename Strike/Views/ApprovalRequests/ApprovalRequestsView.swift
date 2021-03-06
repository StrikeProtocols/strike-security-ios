//
//  ApprovalRequestsView.swift
//  Strike
//
//  Created by Ata Namvari on 2021-04-05.
//

import Foundation

import SwiftUI

struct ApprovalRequestsView: View {
    @Environment(\.strikeApi) var strikeApi

    @State private var didShowApprovalRequests = false

    @RemoteResult private var approvalRequests: [WalletApprovalRequest]?

    var user: StrikeApi.User

    private let appForegroundedPublisher = NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
    private let remoteNotificationPublisher = NotificationCenter.default.publisher(for: .userDidReceiveRemoteNotification)

    var body: some View {
        switch $approvalRequests {
        case .idle:
            ProgressView("Fetching requests...")
                .onAppear(perform: reload)
        case .loading:
            ProgressView("Fetching requests...")
        case .success(let requests):
            ApprovalRequestsList(user: user, requests: requests, onStatusChange: reload, onRefresh: refresh)
                .onAppear(perform: approvalRequestsDidAppear)
                .onReceive(appForegroundedPublisher) { _ in
                    approvalRequestsDidAppear()
                }
                .onReceive(remoteNotificationPublisher) { _ in
                    approvalRequestsDidAppear()
                }
        case .failure(let error):
            RetryView(error: error, action: reload)
        }
    }

    private var loader: MoyaLoader<[WalletApprovalRequest], StrikeApi.Target> {
        strikeApi.provider.loader(for: .walletApprovals)
    }

    private func reload() {
        _approvalRequests.reload(using: loader)

        NotificationCenter.default.post(name: .didReloadApprovals, object: nil)
    }

    private func approvalRequestsDidAppear() {
        guard didShowApprovalRequests else {
            didShowApprovalRequests = true
            return
        }

        _approvalRequests.reload(using: loader, silent: true)

        NotificationCenter.default.post(name: .didReloadApprovals, object: nil)
    }

    private func refresh(_ context: RefreshContext) {
        _approvalRequests.reload(using: loader, silent: true) {
            context.endRefreshing()
        }

        NotificationCenter.default.post(name: .didReloadApprovals, object: nil)
    }
}

#if DEBUG
struct ApprovalRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ApprovalRequestsView(user: .sample)
                .navigationTitle("Approvals")
                .background(Color.Strike.primaryBackground.ignoresSafeArea())
        }
        .withMessageSupport()
    }
}
#endif

extension Notification.Name {
    static let didReloadApprovals = Notification.Name("didReloadApprovals")
}
