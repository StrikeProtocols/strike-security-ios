//
//  PrimaryButtonStyle.swift
//  Strike
//
//  Created by Ata Namvari on 2021-04-20.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration
            .label
            .frame(maxWidth: .infinity, minHeight: 60)
            .font(Font.title.bold())
            .foregroundColor(Color.Strike.green)
            .background(Color.Strike.green.opacity(0.2))
            .cornerRadius(8)
            .progressViewStyle(CircularProgressViewStyle(tint: Color.Strike.green))
    }
}
