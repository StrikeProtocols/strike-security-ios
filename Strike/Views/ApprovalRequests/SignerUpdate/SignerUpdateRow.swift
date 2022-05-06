//
//  SignerUpdateRow.swift
//  Strike
//
//  Created by Ata Namvari on 2022-03-23.
//

import Foundation
import SwiftUI

struct SignerUpdateRow: View {
    var signersUpdate: SignersUpdate

    var body: some View {
        VStack(spacing: 8) {
            Text("\(signersUpdate.slotUpdateType == .Clear ? "Remove" : "Add") Signer")
                .font(.title2.bold())
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20))

            AccountDetail(name: signersUpdate.signer.value.name, subname: signersUpdate.signer.value.email)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .roundedCell()
                .padding(EdgeInsets(top: 16, leading: 10, bottom: 20, trailing: 10))
        }
    }
}

#if DEBUG
struct SignerUpdateRow_Previews: PreviewProvider {
    static var previews: some View {
        SignerUpdateRow(signersUpdate: .sample)
    }
}

extension SignersUpdate {
    static var sample: Self {
        SignersUpdate(slotUpdateType: .SetIfEmpty, signer: SlotSignerInfo(slotId: 2, value: SignerInfo(publicKey: "fdn8398f7n3949dfhkjh498fd7hhjgdfg97hjg", name: "John Malkovich", email: "john@hollywood.com")), signingData: .sample)
    }
}

#endif
