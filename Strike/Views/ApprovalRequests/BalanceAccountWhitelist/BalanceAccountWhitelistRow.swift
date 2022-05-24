//
//  BalanceAccountWhitelistRow.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-24.
//

import Foundation
import SwiftUI


struct BalanceAccountWhitelistRow: View {
    var requestType: SolanaApprovalRequestType
    var update: BalanceAccountAddressWhitelistUpdate

    var body: some View {
        VStack(spacing: 8) {
            Text(requestType.header)
                .font(.title2)
                .bold()
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 20))

            AccountDetail(name: update.accountInfo.name)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .roundedCell()
                .padding(EdgeInsets(top: 16, leading: 10, bottom: 20, trailing: 10))
        }
    }
}

#if DEBUG
struct BalanceAccountWhitelistRow_Previews: PreviewProvider {
    static var previews: some View {
        BalanceAccountWhitelistRow(requestType: .balanceAccountAddressWhitelistUpdate(.sample), update: .sample)
    }
}

extension BalanceAccountAddressWhitelistUpdate {
    static var sample: Self {
        BalanceAccountAddressWhitelistUpdate(accountInfo: .sample, destinations: [.sample, .sample], signingData: .sample)
    }
}
#endif
