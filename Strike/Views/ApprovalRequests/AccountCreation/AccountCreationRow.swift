//
//  AccountCreationRow.swift
//  Strike
//
//  Created by Ata Namvari on 2022-03-23.
//

import Foundation
import SwiftUI

struct AccountCreationRow: View {
    var accountCreation: BalanceAccountCreation

    var body: some View {
        VStack(spacing: 8) {
            Text("New \(accountCreation.accountInfo.accountType.description) Account")
                .font(.title2.bold())
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20))

            AccountDetail(name: accountCreation.accountInfo.name, subname: accountCreation.accountInfo.accountType.description)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .roundedCell()
                .padding(EdgeInsets(top: 16, leading: 10, bottom: 20, trailing: 10))
        }
    }
}

extension AccountType: CustomStringConvertible {
    var description: String {
        switch self {
        case .BalanceAccount:
            return "Wallet"
        case .StakeAccount:
            return "Stake Wallet"
        }
    }
}

#if DEBUG
struct AccountCreationRow_Previews: PreviewProvider {
    static var previews: some View {
        AccountCreationRow(accountCreation: .sample)
    }
}

extension BalanceAccountCreation {
    static var sample: Self {
        BalanceAccountCreation(accountSlot: 1, accountInfo: AccountInfo(name: "Rainbows", identifier: "dffdg", accountType: .BalanceAccount, address: nil), approvalPolicy: ApprovalPolicy(approvalsRequired: 3, approvalTimeout: 4000000, approvers: [SlotSignerInfo(slotId: 3, value: SignerInfo(publicKey: "dsfgsfdg4534gf4", name: "John Q", email: "johnny@crypto.com"))]), whitelistEnabled: .On, dappsEnabled: .On, addressBookSlot: 4, signingData: .sample)
    }
}

#endif
