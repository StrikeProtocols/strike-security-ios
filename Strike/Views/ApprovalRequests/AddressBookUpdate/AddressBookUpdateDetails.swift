//
//  AddressBookUpdateDetails.swift
//  Strike
//
//  Created by Ata Namvari on 2022-05-03.
//

import Foundation
import SwiftUI

struct AddressBookUpdateDetails: View {
    var request: WalletApprovalRequest
    var update: AddressBookUpdate

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

            Spacer()
                .frame(height: 10)

            FactList {
                Fact("Name", update.entry.value.name)
                Fact("Address", update.entry.value.address.masked())
            }
        }
    }
}


#if DEBUG
struct AddressBookUpdateDetails_Previews: PreviewProvider {
    static var previews: some View {
        AddressBookUpdateDetails(request: .sample, update: .sample)
    }
}
#endif
