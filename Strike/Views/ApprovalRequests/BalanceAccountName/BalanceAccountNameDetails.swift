//
//  BalanceAccountNameDetails.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-03.
//

import Foundation
import SwiftUI

struct BalanceAccountNameDetails: View {
    var request: WalletApprovalRequest
    var update: BalanceAccountNameUpdate

    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Text(request.requestType.header)
                .font(.title)
                .bold()
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 22, leading: 10, bottom: 10, trailing: 10))

            HStack(spacing: 0) {
                VStack { Text("From").font(Font.caption.bold()) }
                    .frame(maxWidth: .infinity)
                Spacer()
                    .frame(width: 20)
                VStack { Text("To").font(Font.caption.bold()) }
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing])

            HStack(spacing: 0) {
                AccountDetail(name: update.accountInfo.name)
                    .padding(10)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(Color.Strike.thirdBackground /**/)
                    .cornerRadius(8)

                Text("→")
                    .font(.caption)
                    .foregroundColor(Color.white.opacity(0.5))
                    .frame(width: 20)

                AccountDetail(name: update.newAccountName)
                    .padding(10)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(Color.Strike.thirdBackground /**/)
                    .cornerRadius(8)
            }
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing])

            Spacer()
                .frame(height: 10)

        }
    }
}

#if DEBUG
struct BalanceAccountNameDetails_Previews: PreviewProvider {
    static var previews: some View {
        BalanceAccountNameDetails(request: .sample, update: .sample)
    }
}
#endif


