//
//  MockAuthProvider.swift
//  Strike
//
//  Created by Ata Namvari on 2021-03-18.
//

import Foundation

#if STUBBED || DEBUG
class MockAuthProvider: AuthProvider, ObservableObject {
    init() {}

    @Published var isAuthenticated: Bool = false

    var isExpired: Bool = false

    var bearerToken: String?

    var email: String?

    func authenticate(with sessionToken: String, completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isAuthenticated = true
            self.bearerToken = "[MOCKED_TOKEN]"
            completion(nil)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 10 * 60) {
            self.isExpired = true
            self.bearerToken = nil
        }
    }

    func refresh(completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isExpired = false
            self.bearerToken = "[REFRESHED_TOKEN]"
            completion(nil)
        }
    }

    func invalidate() {
        self.isAuthenticated = false
    }
}
#endif
