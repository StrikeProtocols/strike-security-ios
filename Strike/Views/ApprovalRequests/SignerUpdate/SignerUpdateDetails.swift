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
            FactList {
                Fact("User Name", signersUpdate.signer.value.name)
                Fact("User Email", signersUpdate.signer.value.email)
            }
        }
    }
}


#if DEBUG
struct SignerUpdateDetails_Previews: PreviewProvider {
    static var previews: some View {
        SignerUpdateDetails(request: .sample, signersUpdate: .sample)

        let timerPublisher = Timer.TimerPublisher(interval: 1, runLoop: .current, mode: .default).autoconnect()

        NavigationView {
            ApprovalRequestDetails(user: .sample, request: .sample, timerPublisher: timerPublisher) {
                SignerUpdateDetails(request: .sample, signersUpdate: .sample)
            }
        }
    }
}
#endif
