//
//  SPLTokenAccountCreationDetails.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-03.
//

import Foundation
import SwiftUI

struct SPLTokenAccountCreationDetails: View {
    var request: WalletApprovalRequest
    var creation: SPLTokenAccountCreation
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

            AccountDetail(name: creation.payerBalanceAccount.name, subname: user.organization.name)
                .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                .frame(maxHeight: 60)
                .background(Color.Strike.thirdBackground)
                .cornerRadius(8)

            Spacer()
                .frame(height: 10)

            FactList {
                Fact("Symbol", creation.tokenSymbolInfo.symbol)
            }
        }
    }
}

#if DEBUG
struct SPLTokenAccountCreationDetails_Previews: PreviewProvider {
    static var previews: some View {
        SPLTokenAccountCreationDetails(request: .sample, creation: .sample, user: .sample)
    }
}
#endif
