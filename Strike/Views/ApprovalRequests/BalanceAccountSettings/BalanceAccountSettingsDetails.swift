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
            Text(request.requestType.header)
                .font(.title)
                .bold()
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 22, leading: 10, bottom: 10, trailing: 10))

            AccountDetail(name: update.account.name, subname: user.organization.name)
                .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                .frame(maxHeight: 60)
                .background(Color.Strike.thirdBackground /**/)
                .cornerRadius(8)

            Spacer()
                .frame(height: 10)

            VStack(spacing: 20) {

                switch update.change {
                case .whitelistEnabled(let value):
                    FactsSection(title: "Whitelisting Enabled") {
                        Fact(value ? "Yes" : "No", "")
                    }
                case .dappsEnabled(let value):
                    FactsSection(title: "Supports DApps") {
                        Fact(value ? "Yes" : "No", "")
                    }
                }
            }
        }
    }
}

#if DEBUG
struct BBalanceAccountSettingsDetails_Previews: PreviewProvider {
    static var previews: some View {
        BalanceAccountSettingsDetails(request: .sample, update: .sample, user: .sample)
    }
}
#endif
