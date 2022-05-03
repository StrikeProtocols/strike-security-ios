//
//  WalletConfigPolicyRow.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-03.
//

import Foundation
import SwiftUI


struct WalletConfigPolicyRow: View {
    var update: WalletConfigPolicyUpdate

    var body: some View {
        VStack(spacing: 8) {
            Text("Vault Policy Change")
                .font(.title2)
                .bold()
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 20))

            VStack(spacing: 6) {
                Text(update.approvalPolicy.approvers.count.approversCaption)
            }
            .font(.caption)
            .foregroundColor(Color.white.opacity(0.5))
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))

        }
    }
}

extension Int {
    var approversCaption: String {
        if self == 1 {
            return "\(self) approver"
        } else {
            return "\(self) approvers"
        }
    }
}

#if DEBUG
struct WalletConfigPolicyRow_Previews: PreviewProvider {
    static var previews: some View {
        WalletConfigPolicyRow(update: .sample)
    }
}

extension WalletConfigPolicyUpdate {
    static var sample: Self {
        WalletConfigPolicyUpdate(
            approvalPolicy: .sample,
            signingData: .sample
        )
    }
}

extension ApprovalPolicy {
    static var sample: Self {
        ApprovalPolicy(
            approvalsRequired: 2,
            approvalTimeout: 3000,
            approvers: [SlotSignerInfo.sample]
        )
    }
}

extension SlotSignerInfo {
    static var sample: Self {
        SlotSignerInfo(slotId: 8, value: SignerInfo(publicKey: "1234", name: "John Smith", email: "john@strikeprotocl.com"))
    }
}

#endif
