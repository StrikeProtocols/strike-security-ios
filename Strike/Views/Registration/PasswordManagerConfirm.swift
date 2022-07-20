//
//  PasswordManagerConfirm.swift
//  Strike
//
//  Created by Ata Namvari on 2022-07-12.
//

import SwiftUI

struct PasswordManagerConfirm: View {
    @Environment(\.presentationMode) var presentationMode

    var user: StrikeApi.User
    var phrase: [String]
    var onSuccess: () -> Void

    @State private var pastedPhrase: String = ""
    @State private var incorrectPhrase = false
    @State private var showingSuccess = false

    var body: some View {
        VStack {
            BackButtonBar(caption: "Copy Key", presentationMode: presentationMode)

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
        .onChange(of: pastedPhrase) { newValue in
            let pastedWords = newValue.split(separator: " ").map(String.init)

            if pastedWords == phrase {
                incorrectPhrase = false
                showingSuccess = true
            } else {
                incorrectPhrase = true
            }
        }

        NavigationLink(isActive: .constant(showingSuccess)) {
            KeyConfirmationSuccess(user: user, phrase: phrase, onSuccess: onSuccess)
        } label: {
            EmptyView()
        }
    }
}

#if DEBUG
struct PasswordManagerConfirm_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PasswordManagerConfirm(user: .sample, phrase: [], onSuccess: {})
        }
    }
}
#endif
