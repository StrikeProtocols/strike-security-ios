//
//  String+Masked.swift
//  Strike
//
//  Created by Donald Ness on 2/18/21.
//

import Foundation

extension String {
    func masked() -> String {
        guard count > 8 else { return self }

        return "\(prefix(4))•••\(suffix(4))"
    }
    
    func toWalletName() -> String {
        if self.lowercased().hasSuffix("wallet") {
            return self
        }
        return "\(self) Wallet"
    }
    
    func toVaultName() -> String {
        if self.lowercased().hasSuffix("vault") {
            return self
        }
        return "\(self) Vault"
    }
}
