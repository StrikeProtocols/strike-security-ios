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
}
