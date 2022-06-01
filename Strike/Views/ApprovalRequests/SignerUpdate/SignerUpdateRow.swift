//
//  SignerUpdateRow.swift
//  Strike
//
//  Created by Ata Namvari on 2022-03-23.
//

import Foundation
import SwiftUI

struct SignerUpdateRow: View {
    var requestType: SolanaApprovalRequestType
    var signersUpdate: SignersUpdate

    var body: some View {
        VStack(spacing: 8) {
            Text(requestType.header)
                .font(.title2.bold())
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20))

            Text(signersUpdate.signer.value.email)
                .font(.caption)
                .foregroundColor(Color.white.opacity(0.5))
                .padding(EdgeInsets(top: 2, leading: 20, bottom: 20, trailing: 20))
        }
    }
}

#if DEBUG
struct SignerUpdateRow_Previews: PreviewProvider {
    static var previews: some View {
        SignerUpdateRow(requestType: .signersUpdate(.sample), signersUpdate: .sample)
    }
}

extension SignersUpdate {
    static var sample: Self {
        SignersUpdate(slotUpdateType: .SetIfEmpty, signer: SlotSignerInfo(slotId: 2, value: SignerInfo(publicKey: "fdn8398f7n3949dfhkjh498fd7hhjgdfg97hjg", name: "John Malkovich", email: "john@hollywood.com")), signingData: .sample)
    }
}

#endif
