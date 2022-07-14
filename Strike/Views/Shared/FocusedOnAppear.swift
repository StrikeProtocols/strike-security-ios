//
//  FocusedOnAppear.swift
//  Strike
//
//  Created by Ata Namvari on 2022-07-13.
//

import SwiftUI

@available(iOS 15.0, *)
struct FocusModifer: ViewModifier {
    @FocusState private var fieldIsFocused: Bool

    func body(content: Content) -> some View {
        content
            .focused($fieldIsFocused)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    fieldIsFocused = true
                })
            }
    }
}

extension View {
    @ViewBuilder
    func focusedOnAppear() -> some View {
        if #available(iOS 15.0, *) {
            modifier(FocusModifer())
        } else {
            self
        }
    }
}
