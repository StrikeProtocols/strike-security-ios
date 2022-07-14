//
//  PenAndPaperConfirm.swift
//  Strike
//
//  Created by Ata Namvari on 2022-07-12.
//

import SwiftUI

struct PenAndPaperConfirm: View {
    @Environment(\.presentationMode) var presentationMode

    var user: StrikeApi.User
    var phrase: [String]
    var onSuccess: () -> Void

    @State private var phraseIndex: Int = 0
    @State private var typedPhrase: String = ""
    @State private var showingSuccess = false
    @State private var incorrectPhrase = false

    var currentPhrase: String {
        guard phraseIndex < phrase.count else {
            return ""
        }

        return phrase[phraseIndex]
    }

    var body: some View {
        VStack {
            BackButtonBar(caption: "Write down phrase", presentationMode: presentationMode)

            Spacer()
                .frame(height: 10)

            Text("Enter each word to verify you have the phrase written down correctly")
                .font(.system(size: 18).bold())
                .padding(40)
                .foregroundColor(.white.opacity(0.8))

            Text("Enter word #")
                .font(.system(size: 18).bold())

            Text("\(phraseIndex + 1)")
                .font(.system(size: 78).bold())


            Text("That word is not correct")
                .foregroundColor(.Strike.red)
                .opacity(incorrectPhrase ? 1 : 0)

            TextField("", text: $typedPhrase, onCommit: {
                incorrectPhrase = true
            })
            .autocapitalization(.none)
            .textFieldStyle(DarkRoundedTextFieldStyle(tint: incorrectPhrase ? .Strike.red : .white))
            .padding([.trailing, .leading], 30)
            .multilineTextAlignment(.leading)
            .accentColor(Color.Strike.purple)
            .focusedOnAppear()

            Spacer()
            Spacer()
            Spacer()
        }
        .multilineTextAlignment(.center)
        .buttonStyle(FilledButtonStyle())
        .navigationBarHidden(true)
        .background(StrikeBackground())
        .onChange(of: typedPhrase) { newValue in
            incorrectPhrase = false

            if typedPhrase.lowercased() == currentPhrase.lowercased() {
                moveNext()
            }
        }

        NavigationLink(isActive: .constant(showingSuccess)) {
            KeyConfirmationSuccess(user: user, phrase: phrase, onSuccess: onSuccess)
        } label: {
            EmptyView()
        }
    }

    private func moveNext() {
        guard phraseIndex != phrase.count - 1 else {
            showingSuccess = true
            return
        }

        phraseIndex += 1
        typedPhrase = ""
    }
}

#if DEBUG
struct PenAndPaperConfirm_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PenAndPaperConfirm(user: .sample, phrase: ["these", "are", "test", "words", "they", "go", "on", "and", "on", "until", "there", "is", "no", "more", "these", "are", "test", "words", "they", "go", "on", "and", "on", "until"], onSuccess: {})
        }
    }
}
#endif
