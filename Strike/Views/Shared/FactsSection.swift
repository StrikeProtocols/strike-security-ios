//
//  FactsSection.swift
//  Strike
//
//  Created by Ata Namvari on 2021-05-04.
//

import Foundation
import SwiftUI

struct FactsSection: View {
    var title: String
    @FactBuilder var content: () -> [Fact]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Header(title: title)
            FactList(facts: content)
        }
    }
}

struct Header: View {
    var title: String

    var body: some View {
        Text(title)
            .textCase(.uppercase)
            .multilineTextAlignment(.leading)
            .font(.footnote)
            .padding(5)
            .padding(.leading, 5)
            .frame(minHeight: 22)
            .foregroundColor(Color.white.opacity(0.5))
    }
}
