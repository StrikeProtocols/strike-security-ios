//
//  WithdrawalRow.swift
//  Strike
//
//  Created by Ata Namvari on 2021-04-19.
//

import Foundation
import SwiftUI


struct WithdrawalRow: View {
    var requestType: SolanaApprovalRequestType
    var withdrawal: WithdrawalRequest

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

            if let usdEquivalent = withdrawal.symbolAndAmountInfo.formattedUSDEquivalent {
                Text("\(usdEquivalent) USD equivalent")
                    .font(.caption)
                    .foregroundColor(Color.white.opacity(0.5))
                    .padding(EdgeInsets(top: 2, leading: 20, bottom: 0, trailing: 20))
            }

            HStack(spacing: 0) {
                AccountDetail(name: withdrawal.account.name)
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .roundedCell()

                Text("→")
                    .font(.body)
                    .foregroundColor(Color.white)
                    .frame(width: 20, height: 20)

                AccountDetail(name: withdrawal.destination.name)
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .roundedCell()
            }
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 20, leading: 14, bottom: 20, trailing: 14))
        }
    }
}

extension SymbolAndAmountInfo {
    var formattedUSDEquivalent: String? {
        guard let amount = usdEquivalent, let decimalValue = Decimal(string: amount) else {
            return nil
        }

        return NumberFormatter.usdFormatter.string(from: NSDecimalNumber(decimal: decimalValue))
    }

    var formattedAmount: String {
        var split = amount.split(separator: ".").map { String($0) }

        guard let wholePart = Int(split.removeFirst()) else {
            return amount
        }

        let wholePartString = NumberFormatter.separatorFormatter.string(from: NSNumber(integerLiteral: wholePart)) ?? "0"

        split.insert(wholePartString, at: 0)

        return split.joined(separator: ".")
    }
}

extension NumberFormatter {
    static let usdFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        return formatter
    }()

    static let wholeUSDFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    static let separatorFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
        return formatter
    }()
}

#if DEBUG
struct WithdrawalRow_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalRow(requestType: .withdrawalRequest(.sample), withdrawal: .sample)
    }
}
#endif
