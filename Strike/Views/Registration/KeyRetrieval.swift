//
//  KeyRetrieval.swift
//  Strike
//
//  Created by Ata Namvari on 2022-03-02.
//

import Foundation
import SwiftUI

struct ProfileButton: View {
    var action: () -> Void

    var body: some View {
        HStack {
            Button {
                action()
            } label: {
                Image(systemName: "person")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 20, height: 20)
            .padding(5)

            Spacer()
        }
        .padding()
    }
}

struct KeyRetrieval: View {
    var user: StrikeApi.User
    var publicKey: StrikeApi.PublicKey
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

            Text("It's time to restore your private key using your secret recovery phrase")
                .font(.system(size: 26).bold())
                .multilineTextAlignment(.center)
                .padding(20)

            Text("How did you back it up?")
                .padding()

            NavigationLink {
                PasswordManagerRecovery(user: user, publicKey: publicKey, onSuccess: onSuccess)
            } label: {
                Text("Password Manager")
                    .frame(maxWidth: .infinity)
            }
            .padding([.leading, .trailing], 30)
            .padding([.top, .bottom])

            NavigationLink {
                PenAndPaperRecovery(user: user, publicKey: publicKey, onSuccess: onSuccess)
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
struct KeyRetrieval_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            KeyRetrieval(user: .sample, publicKey: StrikeApi.PublicKey(key: "", walletType: ""), onSuccess: {}, onProfile: {})
        }
    }
}
#endif
