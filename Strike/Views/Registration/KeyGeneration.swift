//
//  KeyGeneration.swift
//  Strike
//
//  Created by Ata Namvari on 2022-03-02.
//

import Foundation
import SwiftUI
import BIP39

struct KeyGeneration: View {
    @State private var phrase = Mnemonic(strength: 256).phrase

    var user: StrikeApi.User
    var onSuccess: () -> Void
    var onProfile: () -> Void

    var body: some View {
        VStack {
            ProfileButton(action: onProfile)
            
            Spacer()

            Image(systemName: "key")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 150)
                .padding(40)

            Text("Your secret recovery phrase has been generated")
                .font(.system(size: 26).bold())
                .multilineTextAlignment(.center)
                .padding(20)

            Text("How would you like to save it?")
                .padding()

            NavigationLink {
                PasswordManager(user: user, phrase: phrase, onSuccess: onSuccess)
            } label: {
                Text("Password Manager")
                    .frame(maxWidth: .infinity)
            }
            .padding([.leading, .trailing], 30)
            .padding([.top, .bottom])

            NavigationLink {
                PenAndPaper(user: user, phrase: phrase, onSuccess: onSuccess)
            } label: {
                Text("Pen and Paper")
                    .frame(maxWidth: .infinity)
            }
            .padding([.leading, .trailing], 30)

            Spacer()
        }
        .buttonStyle(FilledButtonStyle())
        .navigationBarHidden(true)
        .background(StrikeBackground())
    }
}

#if DEBUG
struct KeyGeneration_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            KeyGeneration(user: .sample, onSuccess: {}, onProfile: {})
        }
    }
}
#endif
