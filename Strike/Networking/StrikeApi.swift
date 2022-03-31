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
        case recentBlockHash
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

    fileprivate struct RecentBlockhashRequest: Codable {
        struct Params: Codable {
            var commitment = Configuration.solanaCommitment
        }

        var id = UUID().uuidString
        var method = "getRecentBlockhash"
        var jsonrpc = "2.0"
        var params = [Params()]
    }

    struct Blockhash: Codable {
        struct Result: Codable {
            struct BlockhashData: Codable {
                let blockhash: String
            }

            let value: BlockhashData
        }

        let id: String
        let result: Result

        var value: String {
            result.value.blockhash
        }
    }

    struct ApprovalDispositionRequest: Encodable {
        let disposition: ApprovalDisposition
        let requestID: String
        let requestType: SolanaApprovalRequestType
        let blockhash: Blockhash
        let email: String

        enum CodingKeys: String, CodingKey {
            case signature
            case approvalDisposition
            case recentBlockhash
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(blockhash.value, forKey: .recentBlockhash)
            try container.encode(disposition.rawValue, forKey: .approvalDisposition)

            let signature = try Keychain.signature(for: self, email: email)
            try container.encode(signature, forKey: .signature)
        }
    }
    
    struct SignatureInfo: Codable {
        let publicKey: String
        let signature: String
    }
    
    struct InitiationRequest: Encodable {
        let disposition: ApprovalDisposition
        let requestID: String
        let initiation: MultisigOpInitiation
        let requestType: SolanaApprovalRequestType
        let blockhash: Blockhash
        let email: String
        let opAccountPrivateKey: Curve25519.Signing.PrivateKey
        let dataAccountPrivateKey: Curve25519.Signing.PrivateKey?

        enum CodingKeys: String, CodingKey {
            case initiatorSignature
            case approvalDisposition
            case recentBlockhash
            case opAccountSignatureInfo
            case dataAccountSignatureInfo
            case supplyInstructionInitiatorSignatures
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(blockhash.value, forKey: .recentBlockhash)
            try container.encode(disposition.rawValue, forKey: .approvalDisposition)

            let initiatorSignature = try Keychain.signature(for: self, email: email)
            try container.encode(initiatorSignature, forKey: .initiatorSignature)
            let opAccountSignatureInfo = SignatureInfo(
                publicKey: try self.opAccountPublicKey.base58EncodedString,
                signature: try Keychain.signatureForKey(for: self,  email: email, ephemeralPrivateKey: self.opAccountPrivateKey))
            try container.encode(opAccountSignatureInfo, forKey: .opAccountSignatureInfo)
            if self.initiation.dataAccountCreationInfo != nil && self.dataAccountPrivateKey != nil {
                let dataAccountSignatureInfo = SignatureInfo(
                    publicKey: try self.dataAccountPublicKey.base58EncodedString,
                    signature: try Keychain.signatureForKey(for: self, email: email, ephemeralPrivateKey: self.dataAccountPrivateKey!))
                try container.encode(dataAccountSignatureInfo, forKey: .dataAccountSignatureInfo)
                try container.encode(try Keychain.signatures(for: self, email: email), forKey: .supplyInstructionInitiatorSignatures)
            } else {
                try container.encode([String](), forKey: .supplyInstructionInitiatorSignatures)
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

// MARK: - Moya Target

extension StrikeApi.Target: Moya.TargetType {
    var baseURL: URL {
        switch self {
        case .recentBlockHash:
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
        case .recentBlockHash:
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
             .recentBlockHash,
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
        case .recentBlockHash:
            return .requestJSONEncodable(StrikeApi.RecentBlockhashRequest())
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
        case .recentBlockHash:
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
