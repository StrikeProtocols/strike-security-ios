//
//  SignerUpdateDetails.swift
//  Strike
//
//  Created by Ata Namvari on 2022-03-23.
//

import Foundation
import SwiftUI

struct SignerUpdateDetails: View {
    var request: WalletApprovalRequest
    var signersUpdate: SignersUpdate

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("\(signersUpdate.slotUpdateType == .Clear ? "Remove" : "Add") Signer")
                .font(.title)
                .bold()
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 22, leading: 10, bottom: 10, trailing: 10))

            AccountDetail(name: signersUpdate.signer.value.name, subname: signersUpdate.signer.value.email)
                .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                .frame(maxHeight: 60)
                .background(Color.Strike.thirdBackground)
                .cornerRadius(8)

            FactList {
                Fact("Public Key", signersUpdate.signer.value.publicKey.masked())
            }
        }
    }
}


#if DEBUG
struct SignerUpdateDetails_Previews: PreviewProvider {
    static var previews: some View {
        SignerUpdateDetails(request: .sample, signersUpdate: .sample)
    }
}
#endif
