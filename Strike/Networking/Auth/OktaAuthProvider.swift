//
//  OktaAuthProvider.swift
//  Strike
//
//  Created by Ata Namvari on 2021-03-11.
//

import Foundation
import OktaOidc

class OktaAuthProvider: ObservableObject {
    var stateManager: OktaOidcStateManager? {
        .readFromSecureStorage(for: .current)
    }
}

extension OktaAuthProvider: AuthProvider {
    enum Error: Swift.Error {
        case missingStateManager
    }

    var isAuthenticated: Bool {
        stateManager != nil
    }

    var isExpired: Bool {
        bearerToken == nil
    }

    var bearerToken: String? {
        stateManager?.idToken
    }

    var email: String? {
        guard let idToken = bearerToken, let decodedToken = try? OktaOidcStateManager.decodeJWT(idToken) else {
            return nil
        }

        return decodedToken["email"] as? String
    }

    func authenticate(with sessionToken: String, completion: @escaping (Swift.Error?) -> Void) {
        Configuration.oktaOidc.authenticate(withSessionToken: sessionToken) { [weak self] stateManager, error in
            self?.objectWillChange.send()
            stateManager?.writeToSecureStorage()
            completion(error)
        }
    }

    func refresh(completion: @escaping (Swift.Error?) -> Void) {
        guard let stateManager = stateManager else {
            completion(Error.missingStateManager)
            return
        }

        stateManager.renew { [weak self] (stateManager, error) in
            self?.objectWillChange.send()

            if let stateManager = stateManager {
                stateManager.writeToSecureStorage()
            } else {
                try? self?.stateManager?.removeFromSecureStorage()
            }

            completion(error)
        }
    }

    func invalidate() {
        objectWillChange.send()
        try? stateManager?.removeFromSecureStorage()
    }
}
