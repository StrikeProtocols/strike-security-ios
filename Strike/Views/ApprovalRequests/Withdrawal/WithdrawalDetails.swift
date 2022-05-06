//
//  WithdrawalDetails.swift
//  Strike
//
//  Created by Ata Namvari on 2021-04-19.
//

import Foundation
import SwiftUI


struct WithdrawalDetails: View {
    var request: WalletApprovalRequest
    var withdrawal: WithdrawalRequest

    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            HStack {
                VStack(alignment: .center, spacing: 0) {

                    Text("Send \(withdrawal.symbolAndAmountInfo.formattedAmount) \(withdrawal.symbolAndAmountInfo.symbolInfo.symbol)")
                        .font(.title)
                        .bold()
                        .lineLimit(1)
                        .allowsTightening(true)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.25)
                        .foregroundColor(Color.white)
                        .padding(0)

                    if let usdEquivalent = withdrawal.symbolAndAmountInfo.formattedUSDEquivalent {
                        Text("\(usdEquivalent) USD equivalent")
                            .font(.caption)
                            .foregroundColor(Color.white.opacity(0.5))
                            .padding(.top, 5)
                    }
                }
            }
            .padding()

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
                AccountDetail(name: withdrawal.account.name)
                    .padding(10)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(Color.Strike.thirdBackground /**/)
                    .cornerRadius(8)

                Text("→")
                    .font(.caption)
                    .foregroundColor(Color.white.opacity(0.5))
                    .frame(width: 20)

                AccountDetail(name: withdrawal.destination.name, subname: withdrawal.destination.subName)
                    .padding(10)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(Color.Strike.thirdBackground /**/)
                    .cornerRadius(8)
            }
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing])

            FactList {
                Fact("Address", withdrawal.destination.address.masked())

                if let memo = withdrawal.destination.tag {
                    Fact("Memo", memo)
                }
            }
        }
    }
}

extension WalletApprovalRequest {
    var numberOfApprovalsNeeded: Int {
        numberOfDispositionsRequired - numberOfApprovalsReceived
    }
}

extension DateFormatter {
    static let mediumFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
}

#if DEBUG
struct WithdrawalDetails_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalDetails(request: .sample, withdrawal: .sample)
        let timerPublisher = Timer.TimerPublisher(interval: 1, runLoop: .current, mode: .default).autoconnect()

        NavigationView {
            ApprovalRequestDetails(user: .sample, request: .sample, timerPublisher: timerPublisher) {
                WithdrawalDetails(request: .sample, withdrawal: .sample)
            }
        }
    }
}
#endif


