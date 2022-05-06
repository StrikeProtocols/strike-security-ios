//
//  BalanceAccountNameRow.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-03.
//

import Foundation
import SwiftUI


struct BalanceAccountNameRow: View {
    var update: BalanceAccountNameUpdate

    var body: some View {
        VStack(spacing: 8) {
            Text("Rename Wallet")
                .font(.title2)
                .bold()
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 20))

            HStack(spacing: 0) {
                AccountDetail(name: update.accountInfo.name)
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .roundedCell()

                Text("→")
                    .font(.body)
                    .foregroundColor(Color.white)
                    .frame(width: 20, height: 20)

                AccountDetail(name: update.newAccountName)
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .roundedCell()
            }
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 20, leading: 14, bottom: 20, trailing: 14))
        }
    }
}

#if DEBUG
struct BalanceAccountNameRow_Previews: PreviewProvider {
    static var previews: some View {
        BalanceAccountNameRow(update: .sample)
    }
}

extension BalanceAccountNameUpdate {
    static var sample: Self {
        BalanceAccountNameUpdate(accountInfo: .sample, newAccountName: "My Wallet", signingData: .sample)
    }
}
#endif
