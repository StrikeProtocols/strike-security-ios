//
//  SignInView.swift
//  Strike
//
//  Created by Donald Ness on 3/25/21.
//

import SwiftUI
import OktaAuthNative

struct SignInView: View {
    let authProvider: OktaAuthProvider

    @State private var username = ""
    @State private var password = ""
    
    @State private var isAuthenticating: Bool = false
    
    enum SheetType {
        case recoverPassword
        case lockedOut
        case factorRequired(OktaAuthStatusFactorRequired)
        case factorChallenge(OktaAuthStatusFactorChallenge)
        case unsupportedStatus(OktaAuthStatus)
    }
    
    @State private var currentSheet: SheetType?
    
    enum AlertType {
        case signInError(Error)
    }

    @State private var currentAlert: AlertType?
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 22)
                        .padding(50)

                    Text("Sign in with the account you created on the web")
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing], 60)
                        .padding([.bottom], 20)

                    VStack(alignment: .leading, spacing: 20) {
                        Text("Email")

                        TextField("", text: $username, onEditingChanged: {value in
                            print("sdf: \(value)")
                        })
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .foregroundColor(Color.black)
                            .accentColor(Color.Strike.purple)
                            .textFieldStyle(LightRoundedTextFieldStyle())
                            //.colorScheme(.dark)

                        Text("Password")

                        VStack(alignment: .trailing, spacing: 10) {
                            SecureField("", text: $password) {
                                if canSignIn { signIn() }
                            }
                            .textContentType(.password)
                            .foregroundColor(Color.black)
                            .accentColor(Color.Strike.purple)
                            .textFieldStyle(LightRoundedTextFieldStyle())
                            //.colorScheme(.dark)

                            Button("Forgot password?") {
                                currentSheet = .recoverPassword
                            }
                            .foregroundColor(Color.Strike.purple)
                        }
                    }
                    .padding(35)
                    .background(
                        Rectangle()
                            .border(.gray.opacity(0.4), width: 1)
                            .foregroundColor(.black)
                    )
                    .padding(20)
                    .disabled(isAuthenticating)
                }
            }

            Spacer()

            Button(action: signIn) {
                Text("Sign in")
                    .loadingIndicator(when: isAuthenticating)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(FilledButtonStyle())
            .disabled(!canSignIn)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .padding(30)
        }
        .background(
            StrikeBackground()
        )
        .alert(item: $currentAlert) { item in
            switch item {
            case .signInError:
                return Alert.withDismissButton(title: Text("Sign In Error"), message: Text("Please check your username and password"))
            }
        }
        .sheet(item: $currentSheet) { item in
            NavigationView {
                switch item {
                case .recoverPassword:
                    RecoverPasswordView(username: $username)
                case .lockedOut:
                    LockedOutAccountView()
                case .factorRequired(let status):
                    MFARequiredView(status: status, onReceiveSessionToken: authenticate(sessionToken:))
                case .factorChallenge(let status):
                    MFAChallengeView(status: status, onReceiveSessionToken: authenticate(sessionToken:))
                case .unsupportedStatus(let status):
                    UnsupportedAuthStatusView(status: status)
                }
            }
        }
    }
}

extension SignInView {
    var canSignIn: Bool {
        return !(username.isEmpty || password.isEmpty || isAuthenticating)
    }
    
    private func signIn() {
        authenticate(username: username, password: password)
    }
    
    private func authenticate(username: String, password: String) {
        isAuthenticating = true
        OktaAuthSdk.authenticate(with: Configuration.oktaDomain, username: username, password: password) { status in
            guard let successStatus = status as? OktaAuthStatusSuccess, let sessionToken = successStatus.sessionToken else {
                isAuthenticating = false
                showStatus(status)
                return
            }
            
            authProvider.authenticate(with: sessionToken) { error in
                isAuthenticating = false
                if let error = error {
                    showSignInError(error)
                }
            }
        } onError: { error in
            isAuthenticating = false
            showSignInError(error)
        }
    }
    
    private func authenticate(sessionToken: String) {
        isAuthenticating = true
        authProvider.authenticate(with: sessionToken) { error in
            isAuthenticating = false
            if let error = error {
                showSignInError(error)
            }
        }
    }
}

extension SignInView {
    private func showStatus(_ status: OktaAuthStatus) {
        switch status {
        case is OktaAuthStatusUnauthenticated, is OktaAuthStatusSuccess:
            break
        case is OktaAuthStatusLockedOut:
            currentSheet = .lockedOut
        case let factorRequiredStatus as OktaAuthStatusFactorRequired:
            currentSheet = .factorRequired(factorRequiredStatus)
        case let factorChallengeStatus as OktaAuthStatusFactorChallenge:
            currentSheet = .factorChallenge(factorChallengeStatus)
        default:
            currentSheet = .unsupportedStatus(status)
        }
    }
    
    private func showSignInError(_ error: Error) {
        currentAlert = .signInError(error)
    }
}

extension SignInView.AlertType: Identifiable {
    var id: Int {
        switch self {
        case .signInError:
            return 0
        }
    }
}

extension SignInView.SheetType: Identifiable {
    var id: Int {
        switch self {
        case .lockedOut:
            return 0
        case .recoverPassword:
            return 1
        case .factorRequired:
            return 2
        case .factorChallenge:
            return 3
        case .unsupportedStatus:
            return 4
        }
    }
}

#if DEBUG
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(authProvider: OktaAuthProvider())
    }
}
#endif
