//
//  BalanceAccountPolicyRow.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-03.
//

import Foundation
import SwiftUI


struct BalanceAccountPolicyRow: View {
    var update: BalanceAccountPolicyUpdate

    var body: some View {
        VStack(spacing: 8) {
            Text("Wallet Policy Change")
                .font(.title2)
                .bold()
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 20))

            VStack(spacing: 6) {
                Text(update.approvalPolicy.approvers.count.approversCaption)
            }
            .font(.caption)
            .foregroundColor(Color.white.opacity(0.5))
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))

            AccountDetail(name: update.accountInfo.name)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .roundedCell()
                .padding(EdgeInsets(top: 16, leading: 10, bottom: 20, trailing: 10))
        }
    }
}

#if DEBUG
struct BalanceAccountPolicyRow_Previews: PreviewProvider {
    static var previews: some View {
        BalanceAccountPolicyRow(update: .sample)
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
