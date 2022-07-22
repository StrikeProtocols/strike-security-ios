//
//  BalanceAccountNameRow.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-03.
//

import Foundation
import SwiftUI


struct BalanceAccountNameRow: View {
    var requestType: SolanaApprovalRequestType
    var update: BalanceAccountNameUpdate

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

            Text("\(update.accountInfo.name.toWalletName()) → \(update.newAccountName.toWalletName())")
                .font(.title3)
                .lineLimit(1)
                .allowsTightening(true)
                .foregroundColor(Color.white.opacity(0.8))
                .padding(EdgeInsets(top: 2, leading: 20, bottom: 20, trailing: 20))
        }
    }
}

#if DEBUG
struct BalanceAccountNameRow_Previews: PreviewProvider {
    static var previews: some View {
        BalanceAccountNameRow(requestType: .balanceAccountNameUpdate(.sample), update: .sample)
    }
}

extension BalanceAccountNameUpdate {
    static var sample: Self {
        BalanceAccountNameUpdate(accountInfo: .sample, newAccountName: "My Wallet", signingData: .sample)
    }
}
#endif
