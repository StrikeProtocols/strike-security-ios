//
//  BalanceAccountNameDetails.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-03.
//

import Foundation
import SwiftUI

struct BalanceAccountNameDetails: View {
    var request: WalletApprovalRequest
    var update: BalanceAccountNameUpdate

    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            FactList {
                Fact("Old Wallet Name", update.accountInfo.name)
                Fact("New Wallet Name", update.newAccountName)
            }
        }
    }
}

#if DEBUG
struct BalanceAccountNameDetails_Previews: PreviewProvider {
    static var previews: some View {
        BalanceAccountNameDetails(request: .sample, update: .sample)

        let timerPublisher = Timer.TimerPublisher(interval: 1, runLoop: .current, mode: .default).autoconnect()

        NavigationView {
            ApprovalRequestDetails(user: .sample, request: .sample, timerPublisher: timerPublisher) {
                BalanceAccountNameDetails(request: .sample, update: .sample)
            }
        }
    }
}
#endif


