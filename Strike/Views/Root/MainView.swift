//
//  MainView.swift
//  Strike
//
//  Created by Ata Namvari on 2021-03-10.
//

import Foundation
import SwiftUI

struct MainView: View {
    @Environment(\.strikeApi) var strikeApi

    var onSignOut: () -> Void

    @RemoteResult private var user: StrikeApi.User?

    init(onSignOut: @escaping () -> Void) {
        self.onSignOut = onSignOut
    }

    var body: some View {
        switch $user {
        case .idle:
            SignedInNavigationView(onSignOut: onSignOut) { _ in
                ProgressView()
                    .onAppear(perform: reload)
            }
        case .loading:
            SignedInNavigationView(onSignOut: onSignOut) { _ in
                ProgressView()
            }
        case .failure(let error):
            SignedInNavigationView(onSignOut: onSignOut) { _ in
                RetryView(error: error, action: reload)
            }
        case .success(let user):
            SignedInNavigationView(user: user, onSignOut: onSignOut) { onProfile in
                RegistrationView(user: user, onReloadUser: reload, onProfile: onProfile)
            }
        }
    }

    func reload() {
        _user.reload(using: strikeApi.provider.loader(for: .verifyUser))
    }
}
