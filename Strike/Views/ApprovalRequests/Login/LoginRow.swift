//
//  LoginRow.swift
//  Strike
//
//  Created by Ata Namvari on 2022-04-19.
//

import SwiftUI

struct LoginRow: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Log in")
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
        LoginRow()
    }
}
#endif
