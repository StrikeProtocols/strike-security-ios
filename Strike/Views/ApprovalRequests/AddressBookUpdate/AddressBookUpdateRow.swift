//
//  AddressBookUpdateRow.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-03.
//

import Foundation
import SwiftUI


struct AddressBookUpdateRow: View {
    var requestType: SolanaApprovalRequestType
    var update: AddressBookUpdate

    var body: some View {
        VStack(spacing: 8) {
            Text(requestType.header)
                .font(.title2)
                .bold()
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 20))

            Text(update.entry.value.name)
                .font(.title3)
                .foregroundColor(Color.white.opacity(0.8))
                .padding(EdgeInsets(top: 2, leading: 20, bottom: 20, trailing: 20))
        }
    }
}

#if DEBUG
struct AddressBookUpdateRow_Previews: PreviewProvider {
    static var previews: some View {
        AddressBookUpdateRow(requestType: .addressBookUpdate(.sample), update: .sample)
    }
}

extension AddressBookUpdate {
    static var sample: Self {
        AddressBookUpdate(change: .add, entry: .sample, signingData: .sample)
    }
}

extension SlotDestinationInfo {
    static var sample: Self {
        SlotDestinationInfo(slotId: 7, value: .sample)
    }

    static var sample2: Self {
        SlotDestinationInfo(slotId: 8, value: .sample2)
    }
}

extension DestinationAddress {
    static var sample2: Self {
        DestinationAddress(name: "My Destination", subName: "Subname", address: "dfgdjh324", tag: nil)
    }
}
#endif
