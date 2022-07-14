//
//  KeyRecoverySuccess.swift
//  Strike
//
//  Created by Ata Namvari on 2022-07-13.
//

import SwiftUI

struct KeyRecoverySuccess: View {
    var onSuccess: () -> Void

    var body: some View {
        Group {
            VStack {
                Spacer()

                Image(systemName: "checkmark.circle.fill")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.Strike.green)
                    .background(Color.white)
                    .clipShape(Circle())
                    .padding()
                    .frame(width: 100, height: 100)

                Text("You're all set.")
                    .font(.system(size: 26).bold())
                    .padding()

                Spacer()

                Button {
                    onSuccess()
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .padding(30)

                Spacer()
                    .frame(height: 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .multilineTextAlignment(.center)
        .buttonStyle(FilledButtonStyle())
        .navigationBarHidden(true)
        .background(StrikeBackground())
    }
}

#if DEBUG
struct KeyRecoverySuccess_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            KeyRecoverySuccess(onSuccess: {})
        }
    }
}
#endif
