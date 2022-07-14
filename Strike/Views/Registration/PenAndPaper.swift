//
//  PenAndPaper.swift
//  Strike
//
//  Created by Ata Namvari on 2022-07-12.
//

import SwiftUI

struct PenAndPaper: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var page = 0
    @State private var pagesVisited: Set<Int> = [0]

    var user: StrikeApi.User
    var phrase: [String]
    var onSuccess: () -> Void

    var startIndex: Int {
        page * 4
    }

    var endIndex: Int {
        (page + 1) * 4
    }

    var allPagesVisited: Bool {
        pagesVisited.count == phrase.count / 4
    }

    var body: some View {
        VStack {
            BackButtonBar(caption: "Start over", presentationMode: presentationMode)

            Spacer()

            Text("Write each word down in order")
                .font(.system(size: 26).bold())
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing], 30)

            Text("Showing \(startIndex + 1)-\(endIndex) of \(phrase.count)")
                .foregroundColor(.init(white: 0.5))
                .padding()

            HStack {
                VStack(alignment: .leading, spacing: 30) {
                    ForEach(startIndex..<endIndex, id: \.self) { i in
                        HStack(alignment: .center, spacing: 30) {
                            Text("\(i + 1)")
                                .font(.system(size: 16, design: .monospaced))
                                .foregroundColor(.init(white: 0.5))
                                .frame(width: 20)

                            HStack {
                                Text(phrase[i])
                                    .font(.system(size: 22, design: .monospaced))
                                Spacer()
                            }
                        }
                    }
                }
            }
            .padding(25)
            .padding([.leading, .trailing], 20)
            .background(Color.black.opacity(0.5).border(Color(white: 0.1), width: 1))
            .padding([.leading, .trailing], 50)
            .padding([.bottom, .top], 30)

            Spacer()

            HStack {
                Button {
                    if page == 0 {
                        page = (phrase.count / 4) - 1
                    } else {
                        page = (page - 1) % (phrase.count / 4)
                    }

                    pagesVisited.insert(page)
                } label: {
                    HStack {
                        Image(systemName: "arrowtriangle.left.fill")

                        Text("Previous")
                    }
                }

                Spacer()

                Button {
                    page = (page + 1) % (phrase.count / 4)

                    pagesVisited.insert(page)
                } label: {
                    HStack {
                        Text("Next")

                        Image(systemName: "arrowtriangle.right.fill")
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding()

            NavigationLink {
                PenAndPaperConfirm(user: user, phrase: phrase, onSuccess: onSuccess)
            } label: {
                Text("I saved the phrase →")
                    .frame(maxWidth: .infinity)
            }
            .padding(30)
            .opacity(allPagesVisited ? 1 : 0)

            Spacer()
                .frame(height: 20)
        }
        .buttonStyle(FilledButtonStyle())
        .navigationBarHidden(true)
        .background(StrikeBackground())
    }
}

#if DEBUG
struct PenAndPaper_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PenAndPaper(user: .sample, phrase: ["these", "are", "test", "words", "they", "go", "on", "and", "on", "until", "there", "is", "no", "more", "these", "are", "test", "words", "they", "go", "on", "and", "on", "until"], onSuccess: {})
        }
    }
}
#endif
