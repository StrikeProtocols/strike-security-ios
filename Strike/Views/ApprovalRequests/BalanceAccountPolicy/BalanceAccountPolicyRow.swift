//
//  BalanceAccountPolicyRow.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-03.
//

import Foundation
import SwiftUI


struct BalanceAccountPolicyRow: View {
    var requestType: SolanaApprovalRequestType
    var update: BalanceAccountPolicyUpdate

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

            Text(update.accountInfo.name.toWalletName())
                .font(.title3)
                .foregroundColor(Color.white.opacity(0.8))
                .padding(EdgeInsets(top: 2, leading: 20, bottom: 20, trailing: 20))
        }
    }
}

#if DEBUG
struct BalanceAccountPolicyRow_Previews: PreviewProvider {
    static var previews: some View {
        BalanceAccountPolicyRow(requestType: .balanceAccountPolicyUpdate(.sample), update: .sample)
    }
}

extension BalanceAccountPolicyUpdate {
    static var sample: Self {
        BalanceAccountPolicyUpdate(
            accountInfo: .sample,
            approvalPolicy: .sample,
            signingData: .sample
        )
    }
}
#endif
