//
//  PasswordManagerRecovery.swift
//  Strike
//
//  Created by Ata Namvari on 2022-07-13.
//

import SwiftUI
import BIP39

struct PasswordManagerRecovery: View {
    @Environment(\.presentationMode) var presentationMode

    var user: StrikeApi.User
    var publicKey: StrikeApi.PublicKey
    var onSuccess: () -> Void

    @State private var pastedPhrase: String = ""
    @State private var incorrectPhrase = false
    @State private var showingSuccess = false
    @State private var showingKeySaveErrorAlert = false

    var body: some View {
        VStack {
            BackButtonBar(caption: "Start over", presentationMode: presentationMode)

            Spacer()

            Text("Confirm recovery phrase")
                .font(.system(size: 26).bold())
                .padding()

            if !incorrectPhrase {
                Text("We've cleared your clipboard.")
                    .padding([.leading, .trailing], 50)
                    .padding([.top, .bottom], 10)

                Text("Open your Password Manager, copy your recovery phrase, and paste it here.")
                    .padding([.leading, .trailing], 50)
                    .padding([.top, .bottom], 10)
            } else {
                Text("Uh oh.  That recovery phrase is not correct.")
                    .padding([.leading, .trailing], 50)
                    .padding([.top, .bottom], 10)

                Text("You can try again or go back to copy your recovery phrase.")
                    .padding([.leading, .trailing], 50)
                    .padding([.top, .bottom], 10)
            }

            SecureField("", text: $pastedPhrase)
                .textFieldStyle(DarkRoundedTextFieldStyle(tint: incorrectPhrase ? .Strike.red : .white))
                .padding(30)
                .multilineTextAlignment(.leading)
                .accentColor(Color.Strike.purple)

            Spacer()
            Spacer()
            Spacer()
        }
        .multilineTextAlignment(.center)
        .buttonStyle(FilledButtonStyle())
        .navigationBarHidden(true)
        .background(StrikeBackground())
        .onAppear {
            UIPasteboard.general.string = nil
        }
        .alert(isPresented: $showingKeySaveErrorAlert) {
            Alert(
                title: Text("Something went wrong"),
                message: Text("Could not save your private key to keychain"),
                primaryButton: .default(Text("Try again"), action: {
                    savePrivateKey(phrase: pastedPhrase)
                }),
                secondaryButton: .cancel(Text("Cancel"), action: {
                    pastedPhrase = ""
                })
            )
        }
        .onChange(of: pastedPhrase) { newValue in
            savePrivateKey(phrase: newValue)
        }

        NavigationLink(isActive: .constant(showingSuccess)) {
            KeyRecoverySuccess(onSuccess: onSuccess)
        } label: {
            EmptyView()
        }
    }

    private func savePrivateKey(phrase: String) {
        incorrectPhrase = false

        let pastedWords = phrase.lowercased().split(separator: " ").map(String.init)

        guard pastedWords.count == 24 else {
            return
        }

        do {
            let rootSeed = try Mnemonic(phrase: pastedWords).seed
            let privateKey = try Ed25519HierachicalPrivateKey.fromRootSeed(rootSeed: rootSeed).privateKey
            let publicKeyData = privateKey.publicKey.rawRepresentation
            let phraseEncodedPublicKey = Base58.encode(publicKeyData.bytes)

            if phraseEncodedPublicKey == publicKey.key {
                try Keychain.savePrivateKey(privateKey, rootSeed: rootSeed, email: user.loginName)

                showingSuccess = true
            } else {
                incorrectPhrase = true
            }
        } catch Keychain.KeyError.couldNotSavePrivateKey {
            showingKeySaveErrorAlert = true
        } catch {
            incorrectPhrase = true
        }
    }
}

#if DEBUG
struct PasswordManagerRecovery_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PasswordManagerRecovery(user: .sample, publicKey: StrikeApi.PublicKey(key: "", walletType: ""), onSuccess: {})
        }
    }
}
#endif
