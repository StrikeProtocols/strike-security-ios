//
//  StrikeBackground.swift
//  Strike
//
//  Created by Ata Namvari on 2022-07-12.
//

import SwiftUI

struct StrikeBackground: View {
    var body: some View {
        GeometryReader { geometry in
            RadialGradient(colors: [.Strike.purple, .black], center: .center, startRadius: 0, endRadius: max(geometry.size.height, geometry.size.width) * 0.5)
        }
        .opacity(0.25)
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}
