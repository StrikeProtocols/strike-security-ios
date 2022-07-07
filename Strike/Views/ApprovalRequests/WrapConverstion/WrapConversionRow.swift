//
//  WrapConversionRow.swift
//  Strike
//
//  Created by Ata Namvari on 2022-06-08.
//

import Foundation
import SwiftUI


struct WrapConversionRow: View {
    var requestType: SolanaApprovalRequestType
    var conversion: WrapConversionRequest

    var body: some View {
        VStack {
            Text(requestType.header)
                .font(.title2)
                .bold()
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.25)
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 20))

            if let usdEquivalent = conversion.symbolAndAmountInfo.formattedUSDEquivalent {
                Text("\(usdEquivalent) USD equivalent")
                    .font(.caption)
                    .foregroundColor(Color.white.opacity(0.5))
                    .padding(EdgeInsets(top: 2, leading: 20, bottom: 20, trailing: 20))
            }
        }
    }
}

#if DEBUG
struct WrapConversionRow_Previews: PreviewProvider {
    static var previews: some View {
        WrapConversionRow(requestType: .wrapConversionRequest(.sample), conversion: .sample)
    }
}

extension WrapConversionRequest {
    static var sample: Self {
        WrapConversionRequest(account: .sample, symbolAndAmountInfo: .sample, destinationSymbolInfo: .sample, signingData: .sample)
    }
}

#endif
