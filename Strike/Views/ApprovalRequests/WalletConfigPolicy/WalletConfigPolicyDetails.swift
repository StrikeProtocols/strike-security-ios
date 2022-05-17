//
//  WalletConfigPolicyDetails.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-03.
//

import Foundation
import SwiftUI

struct WalletConfigPolicyDetails: View {
    var request: WalletApprovalRequest
    var update: WalletConfigPolicyUpdate

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

            Spacer()
                .frame(height: 10)

            VStack(spacing: 20) {
                FactsSection(title: "Vault Approvers") {
                    if update.approvalPolicy.approvers.count > 0 {
                        for approver in update.approvalPolicy.approvers {
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
struct WalletConfigPolicyDetails_Previews: PreviewProvider {
    static var previews: some View {
        WalletConfigPolicyDetails(request: .sample, update: .sample)
    }
}
#endif
