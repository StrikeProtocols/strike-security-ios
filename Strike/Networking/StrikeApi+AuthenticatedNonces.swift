//
//  StrikeApi+AuthenticatedNonces.swift
//  Strike
//
//  Created by Ata Namvari on 2022-03-10.
//

import Foundation
import Moya
import LocalAuthentication

extension MoyaProvider where Target == StrikeApi.Target {
    func requestWithNonces(accountAddresses: [String], target: @escaping ([StrikeApi.Nonce]) -> Target, completion: @escaping (Result<Moya.Response, Error>) -> Void) {
        let context = LAContext()

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else {
            completion(.failure(BiometryError.required))
            return
        }

        if accountAddresses.isEmpty {
            authenticatedRequest(context: context, target: target([]), completion: completion)
        } else {
            self.decodableRequest(
                .multipleAccountNonce(StrikeApi.GetMultipleAccountsRequest(accountKeys: accountAddresses)),
                completionQueue: nil
            ) { [weak self] (result: Result<StrikeApi.GetMultipleAccountsResponse, MoyaError>) in
                switch result {
                case .success(let response):
                    self?.authenticatedRequest(context: context, target: target(response.nonces), completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    private func authenticatedRequest(context: LAContext, target: Target, completion: @escaping (Result<Moya.Response, Error>) -> Void) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Identify yourself") { success, error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.request(target) { result in
                    switch result {
                    case .success(let response):
                        completion(.success(response))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
