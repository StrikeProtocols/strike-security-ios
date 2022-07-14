//
//  BackButtonBar.swift
//  Strike
//
//  Created by Ata Namvari on 2022-07-12.
//

import SwiftUI

struct BackButtonBar: View {
    var caption: String

    @Binding var presentationMode: PresentationMode

    var body: some View {
        HStack {
            Button {
                $presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18).weight(.heavy))

                    Text(caption)
                        .font(.system(size: 16).weight(.bold))
                }
            }
            .buttonStyle(PlainButtonStyle())

            Spacer()
        }
        .padding()
    }
}
