//
//  StrikeApi.swift
//  Strike
//
//  Created by Donald Ness on 12/28/20.
//

import Foundation
import CryptoKit

import Moya

struct StrikeApi {
    
    /// The Moya Target definition for this API.
    enum Target {
        case verifyUser
        case walletSigners
        case addWalletSigner(WalletSigner)
        case walletApprovals
        case registerApprovalDisposition(ApprovalDispositionRequest)
        case multipleAccountNonce(GetMultipleAccountsRequest)
        case initiateRequest(InitiationRequest)

        case registerPushToken(String, deviceIdentifier: String)
        case unregisterPushToken(deviceIdentifier: String)
        case connectDApp(code: String)
    }
    
    /// The provider for the Moya Target definition for this API.
    let provider: MoyaProvider<Target>
    
    init(
        authProvider: AuthProvider? = nil,
        stubClosure: @escaping MoyaProvider<Target>.StubClosure = StrikeApi.defaultStubBehaviorClosure()
    ) {
        self.provider = MoyaProvider<Target>(
            requestClosure: Self.authTokenEndpointResolver(authProvider: authProvider),
            stubClosure: stubClosure,
            plugins: [
                AuthProviderPlugin(authProvider: authProvider)
            ]
        )
    }
    
    fileprivate static func defaultStubBehaviorClosure() -> MoyaProvider<Target>.StubClosure {
        return MoyaProvider.neverStub
    }
    
    fileprivate static func authTokenEndpointResolver(authProvider: AuthProvider?, callbackQueue: DispatchQueue = .main) -> MoyaProvider<Target>.RequestClosure {
        return { [weak authProvider] endpoint, closure in
            func attemptRequest() {
                do {
                    let request = try endpoint.urlRequest()
                    closure(.success(request))
                } catch let error as MoyaError {
                    closure(.failure(error))
                } catch {
                    closure(.failure(.underlying(error, nil)))
                }
            }
            
            let originalRequest: URLRequest

            do {
                originalRequest = try endpoint.urlRequest()
            } catch {
                closure(.failure(.underlying(error, nil)))
                return
            }

            guard let authProvider = authProvider, authProvider.isExpired else {
                // In the case user is not authenticated or their token has expired,
                // proceed with the original request.  This will allow the caller
                // to respond to 401 responses appropriately.
                attemptRequest()
                return
            }
            
            DispatchGroup.refreshTokenDispatchGroup.wait()

            guard authProvider.isExpired else {
                attemptRequest()
                return
            }

            DispatchGroup.refreshTokenDispatchGroup.enter()

            authProvider.refresh { (error) in
                DispatchGroup.refreshTokenDispatchGroup.leave()

                if let error = error {
                    callbackQueue.async {
                        closure(.failure(MoyaError.underlying(error, nil)))
                    }
                } else {
                    callbackQueue.async {
                        closure(.success(originalRequest))
                    }
                }
            }
        }
    }
}

extension DispatchGroup {
    fileprivate static let refreshTokenDispatchGroup = DispatchGroup()
}

extension DispatchQueue {
    fileprivate static let refreshTokenDispatchQueue = DispatchQueue(label: "com.strikeprotocols.authorization-queue")
}

extension StrikeApi {
    struct User: Codable, Identifiable {
        let id: String
        let fullName: String
        let loginName: String
        let hasApprovalPermission: Bool
        let organization: Organization
        let useStaticKey: Bool
        let publicKeys: [PublicKey]
    }

    struct PublicKey: Codable {
        let key: String
        let walletType: String
    }
    
    struct Organization: Codable {
        let id: String
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
        }
    }

    struct WalletSigner: Codable {
        let publicKey: String
        let encryptedKey: String
        let walletType: String
    }

    struct ConnectedWallet: Codable {
        struct DAppInfo: Codable {
            let name: String
            let description: String
            let logo: URL?
        }

        let dappInfo: DAppInfo
    }

    struct WalletConnectionError: Codable, Error {
        struct Description: Codable {
            let message: String
        }

        let errors: [Description]
    }

    struct GetMultipleAccountsRequest: Encodable {
        struct Params: Codable {
            var commitment = Configuration.solanaCommitment
            var encoding = "base64"
        }

        enum ParamItem: Encodable {
            case stringList([String])
            case params(Params)

            func encode(to encoder: Encoder) throws {
                switch self {
                case .stringList(let value):
                    try value.encode(to: encoder)
                case .params(let value):
                    try value.encode(to: encoder)
                }
            }
        }

        var id = UUID().uuidString
        var method = "getMultipleAccounts"
        var jsonrpc = "2.0"
        var params: [ParamItem]

        init(accountKeys: [String]) {
            self.params = [
                .stringList(accountKeys),
                .params(Params())
            ]
        }
    }

    struct Nonce: Decodable, Equatable {
        var value: String

        init(_ value: String) {
            self.value = value
        }

        init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            let stringValue = try container.decode(String.self)

            if let value = Data(base64Encoded: stringValue)?.subdata(in: 40 ..< 72).base58String {
                self.value = value
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid Nonce")
            }
        }
    }

    struct GetMultipleAccountsResponse: Decodable {
        struct Result: Decodable {
            struct AccountData: Decodable {
                let data: Nonce
            }

            let value: [AccountData]
        }

        let id: String
        let result: Result

        var nonces: [Nonce] {
            result.value.map(\.data)
        }
    }

    struct ApprovalDispositionRequest: Encodable {
        let disposition: ApprovalDisposition
        let requestID: String
        let requestType: SolanaApprovalRequestType
        let nonces: [Nonce]
        let email: String

        enum CodingKeys: String, CodingKey {
            case signature
            case approvalDisposition
            case nonce
            case nonceAccountAddress
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            if let nonce = nonces.first, let nonceAccountAddress = requestType.nonceAccountAddresses.first {
                try container.encode(nonce.value, forKey: .nonce)
                try container.encode(nonceAccountAddress, forKey: .nonceAccountAddress)
            }

            try container.encode(disposition.rawValue, forKey: .approvalDisposition)

            let signature = try Keychain.signature(for: self, email: email)
            try container.encode(signature, forKey: .signature)
        }
    }
    
    struct InitiationRequest: Encodable {
        let disposition: ApprovalDisposition
        let requestID: String
        let initiation: MultisigOpInitiation
        let requestType: SolanaApprovalRequestType
        let nonces: [Nonce]
        let email: String
        let opAccountPrivateKey: Curve25519.Signing.PrivateKey
        let dataAccountPrivateKey: Curve25519.Signing.PrivateKey?

        enum CodingKeys: String, CodingKey {
            case initiatorSignature
            case approvalDisposition
            case nonce
            case nonceAccountAddress
            case opAccountAddress
            case opAccountSignature
            case supplyDappInstructions
        }

        private struct SupplyDappInstructionsTxSignature: Encodable {
            let nonce: String
            let nonceAccountAddress: String
            let signature: String
        }

        private struct SupplyDAppInstructions: Encodable {
            let dataAccountAddress: String
            let dataAccountSignature: String
            let supplyInstructionInitiatorSignatures: [SupplyDappInstructionsTxSignature]
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            if let nonce = nonces.first, let nonceAccountAddress = requestType.nonceAccountAddresses.first {
                try container.encode(nonce.value, forKey: .nonce)
                try container.encode(nonceAccountAddress, forKey: .nonceAccountAddress)
            }

            try container.encode(disposition.rawValue, forKey: .approvalDisposition)

            let initiatorSignature = try Keychain.signature(for: self, email: email)
            try container.encode(initiatorSignature, forKey: .initiatorSignature)
            try container.encode(try self.opAccountPublicKey.base58EncodedString, forKey: .opAccountAddress)
            try container.encode(try Keychain.signatureForKey(for: self, email: email, ephemeralPrivateKey: self.opAccountPrivateKey), forKey: .opAccountSignature)

            if let dataAccountPrivateKey = dataAccountPrivateKey, initiation.dataAccountCreationInfo != nil {
                let supplyDappInstructions = SupplyDAppInstructions(
                    dataAccountAddress: try self.dataAccountPublicKey.base58EncodedString,
                    dataAccountSignature: try Keychain.signatureForKey(for: self, email: email, ephemeralPrivateKey: dataAccountPrivateKey),
                    supplyInstructionInitiatorSignatures: try supplyInstructions.map({ instruction in
                        SupplyDappInstructionsTxSignature(
                            nonce: instruction.nonce.value,
                            nonceAccountAddress: instruction.nonceAccountAddress,
                            signature: try Keychain.signature(for: instruction, email: email)
                        )
                    })
                )
                
                try container.encode(supplyDappInstructions, forKey: .supplyDappInstructions)
            }
        }
    }
}

struct AuthProviderPlugin: Moya.PluginType {

    weak var authProvider: AuthProvider?

    func prepare(_ request: URLRequest, target: Moya.TargetType) -> URLRequest {
        var request = request

        if let authProvider = authProvider, authProvider.isAuthenticated, let token = authProvider.bearerToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            if let email = authProvider.email, let signature = try? Keychain.signature(for: token, email: email) {
                request.addValue(signature, forHTTPHeaderField: "X-Strike-Authorization-Signature")
            }
        } else {
            debugPrint("Unauthenticated request: \(request)")
        }

        return request
    }
    
    func process(_ result: Result<Moya.Response, MoyaError>, target: Moya.TargetType) -> Result<Moya.Response, MoyaError> {
        switch (result, target) {
        case (.success(let response), _) where response.statusCode == 401:
            debugPrint("401 unauthorized:", String(data: response.data, encoding: .utf8)!)
            defer { authProvider?.invalidate() }
            return result
        default:
            return result
        }
    }
}

extension String: SolanaSignable {
    func signableData(approverPublicKey: String) throws -> Data {
        data(using: .utf8) ?? Data()
    }
}

// MARK: - Moya Target

extension StrikeApi.Target: Moya.TargetType {
    var baseURL: URL {
        switch self {
        case .multipleAccountNonce:
            return Configuration.solanaRpcURL
        default:
            return Configuration.apiBaseURL
        }
    }
    
    var path: String {
        switch self {
        case .verifyUser:
            return "v1/users"
        case .walletSigners,
             .addWalletSigner:
            return "v1/wallet-signers"
        case .walletApprovals:
            return "v1/wallet-approvals"
        case .registerPushToken:
            return "v1/notification-tokens"
        case .unregisterPushToken(let deviceIdentifier):
            return "v1/notification-tokens/\(deviceIdentifier)/ios"
        case .connectDApp:
            return "v1/wallet-connect"
        case .registerApprovalDisposition(let request):
            return "v1/wallet-approvals/\(request.requestID)/dispositions"
        case .multipleAccountNonce:
            return ""
        case .initiateRequest(let request):
            return "v1/wallet-approvals/\(request.requestID)/initiations"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .verifyUser,
             .walletSigners,
             .walletApprovals:
            return .get
        case .connectDApp,
             .addWalletSigner,
             .multipleAccountNonce,
             .registerApprovalDisposition,
             .initiateRequest:
            return .post
        case .registerPushToken:
            return .post
        case .unregisterPushToken:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .verifyUser,
             .walletSigners,
             .walletApprovals:
            return .requestPlain
        case .addWalletSigner(let walletSigner):
            return .requestJSONEncodable(walletSigner)
        case .registerPushToken(let token, let deviceIdentifier):
            #if DEBUG
            return .requestJSONEncodable([
                "deviceType": "ios_test",
                "deviceId": deviceIdentifier,
                "token": token
            ])
            #else
            return .requestJSONEncodable([
                "deviceType": "ios",
                "deviceId": deviceIdentifier,
                "token": token
            ])
            #endif
        case .unregisterPushToken:
            return .requestPlain
        case .connectDApp(let code):
            return .requestJSONEncodable([
                "uri": code
            ])
        case .registerApprovalDisposition(let request):
            return .requestJSONEncodable(request)
        case .multipleAccountNonce(let request):
            return .requestJSONEncodable(request)
        case .initiateRequest(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .verifyUser:
            return Mock.strikeApi.sampleData.verifyUser()
        default:
            return Data()
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .multipleAccountNonce:
            return [:]
        default:
            return [
                "Content-Type": "application/json",
                "X-IsApi": "true"
            ]
        }
    }
}

extension StrikeApi.User: CustomStringConvertible {
    var description: String {
        return "\(fullName) <\(loginName)>"
    }
}
