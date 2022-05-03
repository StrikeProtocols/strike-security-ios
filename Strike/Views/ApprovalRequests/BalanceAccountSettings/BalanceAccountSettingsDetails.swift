//
//  BalanceAccountSettingsDetails.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-03.
//

import Foundation
import SwiftUI

struct BalanceAccountSettingsDetails: View {
    var request: WalletApprovalRequest
    var update: BalanceAccountSettingsUpdate
    var user: StrikeApi.User

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Wallet Setting Change")
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

            ApprovalsNeeded(request: request)

            Spacer()
                .frame(height: 10)

            VStack(spacing: 20) {

                if let whitelistEnabled = update.whitelistEnabled {
                    FactsSection(title: "Whitelisting Enabled") {
                        Fact(whitelistEnabled == .On ? "Yes" : "No", "")
                    }
                }

                if let dappsEnabled = update.dappsEnabled {
                    FactsSection(title: "Supports DApps") {
                        Fact(dappsEnabled == .On ? "Yes" : "No", "")
                    }
                }

                FactList {
                    Fact("Requested By", request.submitterEmail)
                    Fact("Requested Date", DateFormatter.mediumFormatter.string(from: request.submitDate))
                }

            }
        }
        .navigationTitle("Change Details")
    }
}

#if DEBUG
struct BBalanceAccountSettingsDetails_Previews: PreviewProvider {
    static var previews: some View {
        BalanceAccountSettingsDetails(request: .sample, update: .sample, user: .sample)
    }
}
#endif
