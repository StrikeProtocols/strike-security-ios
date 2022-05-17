//
//  LoginRow.swift
//  Strike
//
//  Created by Ata Namvari on 2022-04-19.
//

import SwiftUI

struct LoginRow: View {
    var requestType: SolanaApprovalRequestType

    var body: some View {
        VStack(spacing: 8) {
            Text(requestType.header)
                .font(.title2.bold())
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 16, leading: 20, bottom: 20, trailing: 20))
        }
    }
}

#if DEBUG
struct LoginRow_Previews: PreviewProvider {
    static var previews: some View {
        LoginRow(requestType: .loginApproval(.sample))
    }
}

extension LoginApproval {
    static var sample: Self {
        LoginApproval(jwtToken: "sampleToken")
    }
}

#endif
