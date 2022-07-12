//
//  WithdrawalDetails.swift
//  Strike
//
//  Created by Ata Namvari on 2021-04-19.
//

import Foundation
import SwiftUI

struct WithdrawalDetails: View {
    var request: WalletApprovalRequest
    var withdrawal: WithdrawalRequest

    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            FactList {
                Fact("From Wallet", withdrawal.account.name)
                Fact("Destinaton", withdrawal.destination.name)
                Fact("Destination Address", withdrawal.destination.address.masked())
                if withdrawal.symbolAndAmountInfo.symbolInfo.nftMetadata != nil {
                    Fact("NFT Name", withdrawal.symbolAndAmountInfo.symbolInfo.nftMetadata!.name)
                }
            }
        }
    }
}

extension WalletApprovalRequest {
    var numberOfApprovalsNeeded: Int {
        numberOfDispositionsRequired - numberOfApprovalsReceived
    }
}

extension DateFormatter {
    static let mediumFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
}

#if DEBUG
struct WithdrawalDetails_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalDetails(request: .sample, withdrawal: .sample)
        let timerPublisher = Timer.TimerPublisher(interval: 1, runLoop: .current, mode: .default).autoconnect()

        NavigationView {
            ApprovalRequestDetails(user: .sample, request: .sample, timerPublisher: timerPublisher) {
                WithdrawalDetails(request: .sample, withdrawal: .sample)
            }
        }
    }
}
#endif


