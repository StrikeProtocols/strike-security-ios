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
            Text(request.requestType.header)
                .font(.title)
                .bold()
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 22, leading: 10, bottom: 10, trailing: 10))

            FactList {
                Fact("Signer Name", signersUpdate.signer.value.name)
                Fact("Signer Email", signersUpdate.signer.value.email)
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
