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
                FactList {
                    Fact("Wallet Name", accountCreation.accountInfo.name)
                }

                FactsSection(title: "Wallet Approvers") {
                    if accountCreation.approvalPolicy.approvers.count > 0 {
                        for approver in accountCreation.approvalPolicy.approvers {
                            Fact(approver.value.name, approver.value.email)
                        }
                    } else {
                        Fact("No users may approve requests", "")
                    }
                }

                FactsSection(title: "Approvals Required") {
                    Fact("\(accountCreation.approvalPolicy.approvalsRequired)", "")
                }

                FactsSection(title: "Approval Expiration") {
                    Fact("\(DateComponentsFormatter.abbreviatedFormatter.string(for: DateComponents(second: Int(accountCreation.approvalPolicy.approvalTimeout / 1000))) ?? "")", "")
                }
            }
        }
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
