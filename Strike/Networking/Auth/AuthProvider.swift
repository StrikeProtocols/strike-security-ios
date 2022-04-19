//
//  AuthProvider.swift
//  Strike
//
//  Created by Donald Ness on 3/25/21.
//

import Foundation

protocol AuthProvider: AnyObject {
    var isAuthenticated: Bool { get }
    var isExpired: Bool { get }
    var bearerToken: String? { get }
    var email: String? { get }

    func refresh(completion: @escaping (Error?) -> Void)
    func invalidate()
}
