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
            FactList {
                Fact("Wallet Name", accountCreation.accountInfo.name)
            }

            FactsSection(title: "Approvals") {
                Fact("Approvals Required", "\(accountCreation.approvalPolicy.approvalsRequired)")
                Fact("Approval Expiration", "\(DateComponentsFormatter.abbreviatedFormatter.string(for: DateComponents(second: Int(accountCreation.approvalPolicy.approvalTimeout / 1000))) ?? "")")
            }

            FactsSection(title: "Approvers") {
                if accountCreation.approvalPolicy.approvers.count > 0 {
                    for approver in accountCreation.approvalPolicy.approvers {
                        Fact(approver.value.name, approver.value.email)
                    }
                } else {
                    Fact("No users may approve requests", "")
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

        let timerPublisher = Timer.TimerPublisher(interval: 1, runLoop: .current, mode: .default).autoconnect()

        NavigationView {
            ApprovalRequestDetails(user: .sample, request: .sample, timerPublisher: timerPublisher) {
                AccountCreationDetails(request: .sample, accountCreation: .sample)
            }
        }
    }
}
#endif
