//
//  LoginDetails.swift
//  Strike
//
//  Created by Ata Namvari on 2022-04-19.
//

import SwiftUI

struct LoginDetails: View {
    var requestType: SolanaApprovalRequestType
    var login: LoginApproval

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            FactList {
                Fact("Login Name", login.name)
                Fact("Login Email", login.email)
            }
        }
    }
}

#if DEBUG
struct LoginDetails_Previews: PreviewProvider {
    static var previews: some View {
        LoginDetails(requestType: .loginApproval(.sample), login: .sample)

        let timerPublisher = Timer.TimerPublisher(interval: 1, runLoop: .current, mode: .default).autoconnect()

        NavigationView {
            ApprovalRequestDetails(user: .sample, request: .sample, timerPublisher: timerPublisher) {
                LoginDetails(requestType: .loginApproval(.sample), login: .sample)
            }
        }
    }
}
#endif
