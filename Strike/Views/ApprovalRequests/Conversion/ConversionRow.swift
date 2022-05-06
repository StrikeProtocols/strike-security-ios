//
//  ConversionRow.swift
//  Strike
//
//  Created by Ata Namvari on 2021-08-25.
//

import Foundation
import SwiftUI


struct ConversionRow: View {
    var conversion: ConversionRequest

    var body: some View {
        VStack {
            Text("Convert \(conversion.symbolAndAmountInfo.formattedAmount) \(conversion.symbolAndAmountInfo.symbolInfo.symbol)")
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
                    .padding(EdgeInsets(top: 2, leading: 20, bottom: 0, trailing: 20))
            }

            HStack(spacing: 0) {
                AccountDetail(name: conversion.account.name)
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .roundedCell()

                Text("→")
                    .font(.body)
                    .foregroundColor(Color.white)
                    .frame(width: 20, height: 20)

                AccountDetail(name: conversion.destination.name)
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .roundedCell()
            }
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 20, leading: 14, bottom: 20, trailing: 14))
        }
    }
}

#if DEBUG
struct ConversionRow_Previews: PreviewProvider {
    static var previews: some View {
        ConversionRow(conversion: .sample)
    }
}
#endif
