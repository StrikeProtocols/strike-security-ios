//
//  BalanceAccountSettingsRow.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-03.
//

import Foundation
import SwiftUI


struct BalanceAccountSettingsRow: View {
    var update: BalanceAccountSettingsUpdate

    var body: some View {
        VStack(spacing: 8) {
            Text("Wallet Setting Change")
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
struct BalanceAccountSettingsRow_Previews: PreviewProvider {
    static var previews: some View {
        BalanceAccountSettingsRow(update: .sample)
    }
}

extension BalanceAccountSettingsUpdate {
    static var sample: Self {
        BalanceAccountSettingsUpdate(accountInfo: .sample, whitelistEnabled: .On, dappsEnabled: .Off, signingData: .sample)
    }
}
#endif
