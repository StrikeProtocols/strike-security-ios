//
//  StrikeProgressView.swift
//  Strike
//
//  Created by Ata Namvari on 2022-07-12.
//

import SwiftUI

struct StrikeProgressView: View {
    var text: String

    var body: some View {
        VStack(spacing: 30) {
            Text(text)
                .font(.callout)

            ProgressView()
        }
        .padding(30)
        .background(Color.black)
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .stroke(Color(white: 0.2), lineWidth: 1)
        )
    }
}
