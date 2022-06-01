//
//  BalanceAccountWhitelistDetails.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-24.
//

import Foundation
import SwiftUI

struct BalanceAccountWhitelistDetails: View {
    var request: WalletApprovalRequest
    var update: BalanceAccountAddressWhitelistUpdate
    var user: StrikeApi.User

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            FactsSection(title: "Whitelisted Addresses") {
                if update.destinations.count > 0 {
                    for destination in update.destinations.sorted(by: { $0.destinationName < $1.destinationName }) {
                        Fact(destination.destinationName, destination.value.address.masked())
                    }
                } else {
                    Fact("No whitelisted addresses", "")
                }
            }
        }
    }
}

extension SlotDestinationInfo {
    var destinationName: String {
        value.name
    }
}

#if DEBUG
struct BalanceAccountWhitelistDetails_Previews: PreviewProvider {
    static var previews: some View {
        BalanceAccountWhitelistDetails(request: .sample, update: .sample, user: .sample)

        let timerPublisher = Timer.TimerPublisher(interval: 1, runLoop: .current, mode: .default).autoconnect()

        NavigationView {
            ApprovalRequestDetails(user: .sample, request: .sample, timerPublisher: timerPublisher) {
                BalanceAccountWhitelistDetails(request: .sample, update: .sample, user: .sample)
            }
        }
    }
}
#endif
