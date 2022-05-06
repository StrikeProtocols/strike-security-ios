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
            HStack {
                VStack(alignment: .center, spacing: 0) {

                    Text("Convert \(conversion.symbolAndAmountInfo.formattedAmount) \(conversion.symbolAndAmountInfo.symbolInfo.symbol)")
                        .font(.title)
                        .bold()
                        .lineLimit(1)
                        .allowsTightening(true)
                        .minimumScaleFactor(0.25)
                        .foregroundColor(Color.white)
                        .padding(0)

                    if let usdEquivalent = conversion.symbolAndAmountInfo.formattedUSDEquivalent {
                        Text("\(usdEquivalent) USD equivalent")
                            .font(.caption)
                            .foregroundColor(Color.white.opacity(0.5))
                            .padding(.top, 5)
                    }
                }
            }
            .padding()

            HStack(spacing: 0) {
                VStack { Text("From").font(Font.caption.bold()) }
                    .frame(maxWidth: .infinity)
                Spacer()
                    .frame(width: 20)
                VStack { Text("To").font(Font.caption.bold()) }
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing])

            HStack(spacing: 0) {
                AccountDetail(name: conversion.account.name)
                    .padding(10)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(Color.Strike.thirdBackground /**/)
                    .cornerRadius(8)

                Text("→")
                    .font(.caption)
                    .foregroundColor(Color.white.opacity(0.5))
                    .frame(width: 20)

                AccountDetail(name: conversion.destination.name, subname: conversion.destination.subName)
                    .padding(10)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(Color.Strike.thirdBackground /**/)
                    .cornerRadius(8)
            }
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing])

            ApprovalsNeeded(request: request)

            if let memo = conversion.destination.tag {
                FactList {
                    Fact("Memo", memo)
                }
            }
        }
    }
}

#if DEBUG
struct ConversionDetails_Previews: PreviewProvider {
    static var previews: some View {
        ConversionDetails(request: .sample, conversion: .sample)
            .background(Color.Strike.secondaryBackground.ignoresSafeArea())
    }
}
#endif


