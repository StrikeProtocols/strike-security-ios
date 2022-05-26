//
//  BalanceAccountPolicyDetails.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-03.
//

import Foundation
import SwiftUI

struct BalanceAccountPolicyDetails: View {
    var request: WalletApprovalRequest
    var update: BalanceAccountPolicyUpdate
    var user: StrikeApi.User

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(request.requestType.header)
                .font(.title)
                .bold()
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 22, leading: 10, bottom: 10, trailing: 10))

            AccountDetail(name: update.accountInfo.name, subname: user.organization.name)
                .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                .frame(maxHeight: 60)
                .background(Color.Strike.thirdBackground /**/)
                .cornerRadius(8)

            Spacer()
                .frame(height: 10)

            VStack(spacing: 20) {

                FactsSection(title: "Wallet Approvers") {
                    if update.approvalPolicy.approvers.count > 0 {
                        for approver in update.approvalPolicy.approvers.sorted(by: { $0.value.name < $1.value.name }) {
                            Fact(approver.value.name, approver.value.email)
                        }
                    } else {
                        Fact("No users may approve requests", "")
                    }
                }

                FactsSection(title: "Approvals Required") {
                    Fact("\(update.approvalPolicy.approvalsRequired)", "")
                }

                FactsSection(title: "Approval Expiration") {
                    Fact("\(DateComponentsFormatter.abbreviatedFormatter.string(for: DateComponents(second: Int(update.approvalPolicy.approvalTimeout / 1000))) ?? "")", "")
                }
            }
        }
    }
}

#if DEBUG
struct BalanceAccountPolicyDetails_Previews: PreviewProvider {
    static var previews: some View {
        BalanceAccountPolicyDetails(request: .sample, update: .sample, user: .sample)
    }
}
#endif
