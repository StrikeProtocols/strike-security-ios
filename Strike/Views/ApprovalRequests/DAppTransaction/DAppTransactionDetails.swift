//
//  DAppTransactionDetails.swift
//  Strike
//
//  Created by Ata Namvari on 2022-04-03.
//

import Foundation
import SwiftUI

struct DAppTransactionDetails: View {
    var request: WalletApprovalRequest
    var transactionRequest: DAppTransactionRequest

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("DApp Transaction")
                .font(.title)
                .bold()
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 22, leading: 10, bottom: 10, trailing: 10))

            ApprovalsNeeded(request: request)

            Spacer()
                .frame(height: 10)

            ForEach(0..<transactionRequest.balanceChanges.count, id: \.self) { i in
                let balanceChange = transactionRequest.balanceChanges[i]

                VStack {
                    Text(balanceChange.symbolInfo.symbol)
                        .font(.title2)
                        .bold()
                        .lineLimit(1)
                        .allowsTightening(true)
                        .minimumScaleFactor(0.25)
                        .foregroundColor(Color.white)
                        .padding(EdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 20))

                    Text(balanceChange.amount)
                        .font(Font.subheadline)
                        .foregroundColor(balanceChange.isNegative ? Color.red : Color.green)

                    if let usdEquivalent = balanceChange.formattedUSDEquivalent {
                        Text(usdEquivalent)
                            .font(.caption)
                            .foregroundColor(Color.white.opacity(0.5))
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    }

                    HStack(spacing: 0) {
                        AccountDetail(name: transactionRequest.dappInfo.name)
                            .padding(10)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .roundedCell()

                        Text(balanceChange.isNegative ? "←" : "→")
                            .font(.body)
                            .foregroundColor(Color.white)
                            .frame(width: 20, height: 20)

                        AccountDetail(name: transactionRequest.account.name)
                            .padding(10)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .roundedCell()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 5, leading: 14, bottom: 5, trailing: 14))
                }
            }
            .padding([.bottom], 20)

            FactList {
                Fact("Requested By", request.submitterEmail)
                Fact("Requested Date", DateFormatter.mediumFormatter.string(from: request.submitDate))
            }

        }
        .navigationTitle("Change Details")
    }
}

#if DEBUG
struct DAppTransactionDetails_Previews: PreviewProvider {
    static var previews: some View {
        DAppTransactionDetails(request: .sample, transactionRequest: .sample)
    }
}
#endif
