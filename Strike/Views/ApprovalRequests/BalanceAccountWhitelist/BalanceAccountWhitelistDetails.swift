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
            Text(request.requestType.header)
                .font(.title)
                .bold()
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 22, leading: 10, bottom: 10, trailing: 10))

            AccountDetail(name: update.accountInfo.name, subname: user.organization.name)
                .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                .frame(maxHeight: 60)
                .background(Color.Strike.thirdBackground /**/)
                .cornerRadius(8)

            Spacer()
                .frame(height: 10)

            VStack(spacing: 20) {
                FactsSection(title: "Whitelisted Addresses") {
                    if update.destinations.count > 0 {
                        for destination in update.destinations.sorted(by: { $0.destinationName < $1.destinationName }) {
                            Fact(destination.value.name, destination.value.address.masked())
                        }
                    } else {
                        Fact("No whitelisted addresses", "")
                    }
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
    }
}
#endif
