//
//  DarkRoundedTextFieldStyle.swift
//  Strike
//
//  Created by Ata Namvari on 2022-07-12.
//

import SwiftUI

struct DarkRoundedTextFieldStyle: TextFieldStyle {
    var tint: Color = .white

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color.black)
            .foregroundColor(tint)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(tint.opacity(0.8), lineWidth: 1)
            )
            .cornerRadius(8)
    }
}

struct LightRoundedTextFieldStyle: TextFieldStyle {
    var tint: Color = .black

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color.white)
            .foregroundColor(tint)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(tint.opacity(0.8), lineWidth: 1)
            )
            .cornerRadius(8)
    }
}
