//
//  ResetPasswordView.swift
//  Strike
//
//  Created by Donald Ness on 3/27/21.
//

import SwiftUI

struct RecoverPasswordView: View {
    @Environment(\.presentationMode) var presentation
    @Environment(\.strikeApi) var strikeApi
    
    @Binding var username: String

    @State private var isLoading: Bool = false
    
    enum AlertType {
        case recoverPasswordError(Error)
        case success
    }

    @State private var currentAlert: AlertType?
    
    var body: some View {
        VStack {
            VStack {
                Spacer()

                Text("Enter the email address associated with your account.")
                    .padding()

                TextField("Email", text: $username)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .foregroundColor(Color.white)
                    .accentColor(Color.Strike.purple)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(isLoading)
                    .padding()

                Spacer()

                Button(action: recoverPassword) {
                    Text("Reset via Email")
                        .loadingIndicator(when: isLoading)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(FilledButtonStyle())
                .disabled(username.isEmpty || isLoading)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .padding()
            }
        }
        .background(
            Color.Strike.primaryBackground
                .ignoresSafeArea()
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Password Reset")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: close) {
                    Image(systemName: "xmark")
                }
                .foregroundColor(.white)
            }
        }
        .alert(item: $currentAlert) { item in
            switch item {
            case .recoverPasswordError:
                return Alert.withDismissButton(title: Text("Reset Password Error"), message: Text("Could not reset your password"))
            case .success:
                return Alert(
                    title: Text("Password Reset"),
                    message: Text("Check your email for a link to reset your password"),
                    dismissButton: .default(Text("Ok"), action: {
                        presentation.wrappedValue.dismiss()
                    })
                )
            }
        }
    }
    
    private func recoverPassword() {
        isLoading = true

        strikeApi.provider.request(.resetPassword(username)) { result in
            isLoading = false

            switch result {
            case .failure(let error):
                currentAlert = .recoverPasswordError(error)
            case .success:
                currentAlert = .success
            }
        }
    }
    
    private func close() {
        presentation.wrappedValue.dismiss()
    }
}

extension RecoverPasswordView.AlertType: Identifiable {
    var id: Int {
        switch self {
        case .recoverPasswordError:
            return 0
        case .success:
            return 1
        }
    }
}

#if DEBUG
struct RecoverPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        RecoverPasswordView(username: .constant(""))
    }
}
#endif
