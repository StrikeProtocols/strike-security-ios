//
//  FactList.swift
//  Strike
//
//  Created by Donald Ness on 2/18/21.
//

import SwiftUI

struct FactList: View {
    struct Item {
        enum Style {
            case `default`
            case deleted
            case new
            case updated
        }

        var content: AnyView
        var style: Style = .default
    }

    var items: [Item]

    init(@FactBuilder facts: () -> [FactList.Item]) {
        self.items = facts()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<items.count, id: \.self) { index in
                items[index].content
                    .padding([.leading, .trailing], 10)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(RowBackground(alternate: index % 2 == 1, style: items[index].style))
            }
        }
    }
}

struct RowBackground: View {
    var alternate: Bool
    var style: FactList.Item.Style

    var body: some View {
        switch (style, alternate) {
        case (.deleted, false):
            Color.Strike.red.opacity(0.08)
        case (.new, false):
            Color.Strike.green.opacity(0.08)
        case (.updated, false):
            Color.Strike.purple.opacity(0.08)
        case (.deleted, true):
            VStack {
                Divider()
                Spacer()
                Divider()
            }
            .background(Color.Strike.red.opacity(0.08))
        case (.new, true):
            VStack {
                Divider()
                Spacer()
                Divider()
            }
            .background(Color.Strike.green.opacity(0.08))
        case (.updated, true):
            VStack {
                Divider()
                Spacer()
                Divider()
            }
            .background(Color.Strike.purple.opacity(0.08))
        case (_, true):
            VStack {
                Divider()
                Spacer()
                Divider()
            }
            .background(Color.black)
        case (_, false):
            Color.Strike.secondaryBackground
        }
    }
}

typealias Fact = FactList.Item

struct EmptyFact {}

@resultBuilder
struct FactBuilder {
    static func buildBlock(_ factArrays: [Fact]?...) -> [Fact] {
        factArrays.compactMap { $0 }.flatMap { $0 }
    }

    static func buildExpression(_ fact: Fact) -> [Fact] {
        [fact]
    }

    static func buildIf(_ facts: [Fact]?) -> [Fact] {
        facts ?? []
    }

    static func buildEither(first: [Fact]) -> [Fact] {
        first
    }

    static func buildEither(second: [Fact]) -> [Fact] {
        second
    }

    static func buildArray(_ components: [[Fact]]) -> [Fact] {
        components.flatMap({ $0 })
    }

    static func buildExpression(_ expression: EmptyFact) -> [Fact] {
        []
    }
}

extension Fact {
    init<Content>(style: Style = .default, @ViewBuilder content: () -> Content) where Content : View {
        self.init(content: AnyView(content()), style: style)
    }

    init<Content>(_ name: String, style: Style = .default, action: (() -> Void)? = nil, @ViewBuilder content: () -> Content) where Content : View {
        self.init(
            content: AnyView(
                HStack(alignment: .firstTextBaseline) {
                    Text(name)
                        .strikethrough(style == .deleted)
                        .font(.subheadline)
                        .foregroundColor(Color.white)

                    Spacer()

                    if let action = action {
                        Button(action: action) {
                            content()
                                .font(.subheadline.bold())
                                .foregroundColor(Color.white)
                        }
                    } else {
                        content()
                            .font(.subheadline.bold())
                            .foregroundColor(Color.white)
                    }
                }
            ),
            style: style
        )
    }

    init(_ name: String, _ value: String, style: Style = .default, action: (() -> Void)? = nil) {
        self.init(name, style: style, action: action) {
            Text(value)
                .strikethrough(style == .deleted)
        }
    }
}

struct ValueList<Element, Content>: View where Content : View {
    var elements: [Element]
    @ViewBuilder var content: (Element) -> Content

    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            ForEach(0..<elements.count, id: \.self) { idx in
                content(elements[idx])
            }
        }
        .padding([.top, .bottom], 14)
    }
}

#if DEBUG
struct FactList_Previews: PreviewProvider {
    static var previews: some View {
        FactList {
            FactList.Item("Requested By", "john@example.com")
            FactList.Item("Requested Date", "Feb 18, 2021 at 5:20:56 PM")
            FactList.Item("Policy Name", "Large Transfers")
        }
        .background(Color.Strike.secondaryBackground)
    }
}
#endif
