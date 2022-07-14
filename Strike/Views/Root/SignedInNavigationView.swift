//
//  SignedInNavigationView.swift
//  Strike
//
//  Created by Ata Namvari on 2021-05-19.
//

import Foundation
import SwiftUI

struct SignedInNavigationView<Content>: View where Content : View {
    @State private var showingAlert = false
    @State private var activeSheet: Sheet?

    enum Sheet {
        case profile
        case dapp
    }

    @EnvironmentObject private var viewRouter: ViewRouter

    var user: StrikeApi.User?
    var onSignOut: () -> Void
    @ViewBuilder var content: (@escaping () -> Void) -> Content

    var body: some View {
        NavigationView {
            content({ activeSheet = .profile })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.Strike.primaryBackground.ignoresSafeArea())
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading:
                                        Button(action: { activeSheet = .profile }, label: {
                                            Image(systemName: "person")
                                                .foregroundColor(.white)
                                        })
                )
                .sheet(item: $activeSheet) { sheet in
                    switch sheet {
                    case .profile:
                        Profile(user: user, onSignOut: onSignOut)
                    case .dapp:
                        DAppScan()
                    }
                }
                .onReceive(viewRouter.$showSupport) { showSupport in
                    guard user != nil, activeSheet == nil, showSupport else { return }
                    
                    activeSheet = .profile
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension SignedInNavigationView.Sheet: Identifiable {
    var id: Int {
        switch self {
        case .profile:
            return 0
        case .dapp:
            return 1
        }
    }
}
