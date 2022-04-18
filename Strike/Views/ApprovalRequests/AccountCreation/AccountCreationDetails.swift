//
//  AccountCreationDetails.swift
//  Strike
//
//  Created by Ata Namvari on 2022-03-23.
//

import Foundation
import SwiftUI

struct AccountCreationDetails: View {
    var request: WalletApprovalRequest
    var accountCreation: BalanceAccountCreation

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("New Account")
                .font(.title)
                .bold()
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 22, leading: 10, bottom: 10, trailing: 10))

            AccountDetail(name: accountCreation.accountInfo.name, subname: accountCreation.accountInfo.accountType.description)
                .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                .frame(maxHeight: 60)
                .background(Color.Strike.thirdBackground)
                .cornerRadius(8)

            ApprovalsNeeded(request: request)

            Spacer()
                .frame(height: 10)

            VStack(spacing: 20) {
                FactsSection(title: "Who can approve outbound transfers") {
                    if accountCreation.approvalPolicy.approvers.count > 0 {
                        for approver in accountCreation.approvalPolicy.approvers {
                            Fact(approver.value.name, approver.value.email)
                        }
                    } else {
                        Fact("No users may approve requests", "")
                    }
                }

                FactsSection(title: "Approvals required for outbound transfers") {
                    Fact("\(accountCreation.approvalPolicy.approvalsRequired)", "")
                }

                FactsSection(title: "Approval timeout") {
                    Fact("\(DateComponentsFormatter.abbreviatedFormatter.string(for: DateComponents(second: Int(accountCreation.approvalPolicy.approvalTimeout / 1000))) ?? "")", "")
                }

                FactsSection(title: "Whitelisting Enabled") {
                    Fact(accountCreation.whitelistEnabled == .On ? "Yes" : "No", "")
                }

                FactsSection(title: "Supports DApps") {
                    Fact(accountCreation.dappsEnabled == .On ? "Yes" : "No", "")
                }  
            }
        }
        .navigationTitle("Change Details")
    }
}

extension DateComponentsFormatter {
    static let abbreviatedFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
}

#if DEBUG
struct AccountCreationDetails_Previews: PreviewProvider {
    static var previews: some View {
        AccountCreationDetails(request: .sample, accountCreation: .sample)
    }
}
#endif
