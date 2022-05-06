//
//  AddressBookUpdateRow.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-03.
//

import Foundation
import SwiftUI


struct AddressBookUpdateRow: View {
    var update: AddressBookUpdate

    var body: some View {
        VStack(spacing: 8) {
            Text(update.change.title)
                .font(.title2)
                .bold()
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 20))

            VStack(spacing: 6) {
                Text(update.entry.value.name)
            }
            .font(.caption)
            .foregroundColor(Color.white.opacity(0.5))
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
        }
    }
}

extension AddressBookUpdate.Change {
    var title: String {
        switch self {
        case .add:
            return "Add Address Book Entry"
        case .remove:
            return "Remove Address Book Entry"
        }
    }
}

#if DEBUG
struct AddressBookUpdateRow_Previews: PreviewProvider {
    static var previews: some View {
        AddressBookUpdateRow(update: .sample)
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
