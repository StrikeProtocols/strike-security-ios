//
//  LoginDetails.swift
//  Strike
//
//  Created by Ata Namvari on 2022-04-19.
//

import SwiftUI

struct LoginDetails: View {
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Login Attempt")
                .font(.title)
                .bold()
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 22, leading: 10, bottom: 20, trailing: 10))
        }
        .navigationTitle("Authentication")
    }
}
