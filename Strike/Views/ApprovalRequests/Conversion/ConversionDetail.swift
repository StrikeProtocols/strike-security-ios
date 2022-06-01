//
//  ConversionDetail.swift
//  Strike
//
//  Created by Ata Namvari on 2021-08-25.
//

import Foundation
import SwiftUI

struct ConversionDetails: View {
    var request: WalletApprovalRequest
    var conversion: ConversionRequest

    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            FactList {
                Fact("From Wallet", conversion.account.name)
                Fact("Destinaton", conversion.destination.name)
                Fact("Destination Address", conversion.destination.address.masked())
            }
        }
    }
}

#if DEBUG
struct ConversionDetails_Previews: PreviewProvider {
    static var previews: some View {
        ConversionDetails(request: .sample, conversion: .sample)
            .background(Color.Strike.secondaryBackground.ignoresSafeArea())

        let timerPublisher = Timer.TimerPublisher(interval: 1, runLoop: .current, mode: .default).autoconnect()
        
        NavigationView {
            ApprovalRequestDetails(user: .sample, request: .sample, timerPublisher: timerPublisher) {
                ConversionDetails(request: .sample, conversion: .sample)
            }
        }
    }
}
#endif


