//
//  Configuration.swift
//  Strike
//
//  Created by Donald Ness on 1/26/21.
//

import Foundation
import OktaOidc

struct Configuration {
    static let termsOfServiceURL: URL = URL(string: "https://strikeprotocols.com/terms-of-service.html")!
    static let privacyPolicyURL: URL = URL(string: "https://strikeprotocols.com/privacy-policy.html")!
    static let gk8PublicKey: String = stringValue(for: "GK8_PUBLIC_KEY")
    static let apiBaseURL: URL = URLValue(for: "API_BASE_URL")
    static let oktaDomain: URL = URLValue(for: "OKTA_DOMAIN")
    static let oktaOidc: OktaOidc = oktaOidcValue(for: "OKTA")
    static let raygunApiKey: String = stringValue(for: "RAYGUN_API_KEY")
    static let raygunEnabled: Bool = stringValue(for: "RAYGUN_ENABLED").lowercased() == "yes"
    static let solanaRpcURL = URLValue(for: "SOLANA_RPC_URL")
    static let solanaCommitment = stringValue(for: "SOLANA_COMMITMENT")
    static let strikeAuthBaseURL: URL = URLValue(for: "STRIKE_AUTH_BASE_URL")
}

extension Configuration {
    static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary?["Configuration"] as? [String: Any] else {
            fatalError("`Info.plist` must contain a dictionary under `Configuration`")
        }

        return dict
    }()

    static func URLValue(for key: String) -> URL {
        guard let urlString = infoDictionary[key] as? String else {
            fatalError("`Info.plist` must contain key `\(key)`")
        }

        guard let url = URL(string: urlString) else {
            fatalError("`\(key)` is an invalid URL in `Info.plist`")
        }

        return url
    }

    static func stringValue(for key: String) -> String {
        guard let string = infoDictionary[key] as? String else {
            fatalError("`Info.plist` must contain key `\(key)`")
        }

        return string
    }

    static func dictionaryValue(for key: String) -> [String: String] {
        guard let dict = infoDictionary[key] as? [String: String] else {
            fatalError("`Info.plist` must contain a dictionary for key `\(key)`")
        }

        return dict
    }
    
    static func oktaOidcConfigValue(for key: String) -> OktaOidcConfig {
        guard let config = try? OktaOidcConfig(with: dictionaryValue(for: key)) else {
            fatalError("`Info.plist` must contain an OktaOidcConfig for key `\(key)`")
        }

        config.noSSO = true

        return config
    }
    
    static func oktaOidcValue(for key: String) -> OktaOidc {
        let config = oktaOidcConfigValue(for: key)
        
        guard let oidc = try? OktaOidc(configuration: config) else {
            fatalError("`Info.plist` contains an invalid OktaOidcConfig for key `\(key)`")
        }

        return oidc
    }
}

extension OktaOidcConfig {
    static let current: OktaOidcConfig = {
        Configuration.oktaOidc.configuration
    }()
}
