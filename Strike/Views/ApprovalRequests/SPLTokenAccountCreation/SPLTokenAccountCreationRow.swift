//
//  SPLTokenAccountCreationRow.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-03.
//

import Foundation
import SwiftUI

struct SPLTokenAccountCreationRow: View {
    var requestType: SolanaApprovalRequestType
    var creation: SPLTokenAccountCreation

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

            Text(creation.tokenSymbolInfo.symbol)
                .font(.caption)
                .foregroundColor(Color.white.opacity(0.5))
                .padding(EdgeInsets(top: 2, leading: 20, bottom: 20, trailing: 20))
        }
    }
}

#if DEBUG
struct SPLTokenAccountCreationRow_Previews: PreviewProvider {
    static var previews: some View {
        SPLTokenAccountCreationRow(requestType: .splTokenAccountCreation(.sample), creation: .sample)
    }
}

extension SPLTokenAccountCreation {
    static var sample: Self {
        SPLTokenAccountCreation(payerBalanceAccount: .sample, balanceAccounts: [.sample], tokenSymbolInfo: .sample, signingData: .sample)
    }
}
#endif
