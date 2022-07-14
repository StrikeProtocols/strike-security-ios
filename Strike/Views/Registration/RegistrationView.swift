//
//  RegistrationView.swift
//  Strike
//
//  Created by Ata Namvari on 2021-04-01.
//

import Foundation
import SwiftUI

struct RegistrationView: View {
    @Environment(\.strikeApi) var strikeApi

    @State private var storedPublicKey: String?

    var user: StrikeApi.User
    var onReloadUser: () -> Void
    var onProfile: () -> Void

    init(user: StrikeApi.User, onReloadUser: @escaping () -> Void, onProfile: @escaping () -> Void) {
        self.user = user
        self.onReloadUser = onReloadUser
        self.onProfile = onProfile
        self._storedPublicKey = State(initialValue: Keychain.publicKey(email: user.loginName))
    }

    var body: some View {
        switch (storedPublicKey, user.publicKeys.first) {
        case (_, .none):
            KeyGeneration(user: user, onSuccess: onReloadUser, onProfile: onProfile)
        case (.none, .some(let remotePublicKey)):
            KeyRetrieval(user: user, publicKey: remotePublicKey) {
                storedPublicKey = Keychain.publicKey(email: user.loginName)
            } onProfile: {
                onProfile()
            }
        case (.some(let storedPublicKey), .some(let remotePublicKey)) where storedPublicKey == remotePublicKey.key:
            ApprovalRequestsView(user: user)
                .navigationTitle("Approvals")
                .onFirstTimeAppear(perform: registerForRemoteNotifications)
        case (.some, .some):
            Text("Keys do not match, call support")
        }
    }

    private func registerForRemoteNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else { return }

            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

#if DEBUG
struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(user: .sample, onReloadUser: { }, onProfile: {})
    }
}
#endif
