//
//  ShowCaseHelper.swift
//  showOverlayTest
//
//  Created by Bryan Vernanda on 28/10/24.
//

import SwiftUI

/// custom show case view extension
extension View {
    @ViewBuilder
    func showCase(order: Int, title: String, cornerRadius: CGFloat, style: RoundedCornerStyle, scale: CGFloat = 1) -> some View {
        self
        /// storing it in Anchor Preference
            .anchorPreference(key: HighlightAnchorKey.self, value: .bounds) { anchor in
                let highlight = Highlight(anchor: anchor, title: title, cornerRadius: cornerRadius, style: style, scale: scale)
                return [order: highlight]
            }
    }
}

/// showcase root view modifier
struct ShowCaseRoot: ViewModifier {
    var showHighlights: Bool
    var onFinished: () -> ()
    
    /// View properties
    @State private var highlightOrder: [Int] = []
    @State private var currentHightlight: Int = 0
    @State private var showView: Bool = true
    /// popover
    @State private var showTitle: Bool = true
    /// Namespace ID, for smooth shape transitions
    @Namespace private var animation
    func body(content: Content) -> some View {
        content
            .onPreferenceChange(HighlightAnchorKey.self) { value in
                highlightOrder = Array(value.keys).sorted()
            }
            .overlayPreferenceValue(HighlightAnchorKey.self) { preferences in
                if highlightOrder.indices.contains(currentHightlight), showHighlights, showView {
                    if let highlight = preferences[highlightOrder[currentHightlight]] {
                        HighlightView(highlight)
                    }
                }
            }
    }
    
    @ViewBuilder
     func HighlightView(_ highlight: Highlight) -> some View {
         GeometryReader { proxy in
             let highlightRect = proxy[highlight.anchor]
             let safeArea = proxy.safeAreaInsets
             
             Rectangle()
                 .fill(.black.opacity(0.5))
                 .reverseMask {
                     Rectangle()
                         .matchedGeometryEffect(id: "HIGHLIGHTSHAPE", in: animation)
                         .frame(width: highlightRect.width + 5, height: highlightRect.height + 5)
                         .clipShape(RoundedRectangle(cornerRadius: highlight.cornerRadius, style: highlight.style))
                         .scaleEffect(highlight.scale)
                         .offset(x: highlightRect.minX - 2.5, y: highlightRect.minY + safeArea.top - 2.5)
                 }
                 .ignoresSafeArea()
                 .onChange(of: showTitle) { _, newValue in
                     if !newValue {
                         if currentHightlight >= highlightOrder.count - 1 {
                             withAnimation(.easeInOut(duration: 0.25)) {
                                 showView = false
                             }
                             onFinished()
                         } else {
                             withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.7)) {
                                 currentHightlight += 1
                             }
                             
                             DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                 showTitle = true
                             }
                         }
                     }
                 }
             
             Rectangle()
                 .foregroundColor(.clear)
                 /// Adding border
                 /// Simply extend its size
                 .frame(width: highlightRect.width + 20, height: highlightRect.height + 20)
                 .clipShape(RoundedRectangle(cornerRadius: highlight.cornerRadius, style: highlight.style))
                 .popover(isPresented: $showTitle, content: {
                     Text(highlight.title)
                         .padding(.horizontal, 10)
                         .presentationCompactAdaptation(.popover)
                 })
                 .scaleEffect(highlight.scale)
                 .offset(x: highlightRect.minX - 10, y: highlightRect.minY - 10)
         }
    }
}


/// custom view modifier for inner/reverse mask
extension View {
    @ViewBuilder
    func reverseMask<Content: View>(alignment: Alignment = .topLeading, @ViewBuilder content: @escaping () -> Content)
    -> some View {
        self
            .mask {
                Rectangle()
                    .overlay(alignment: .topLeading) {
                        content()
                            .blendMode(.destinationOut)
                    }
            }
    }
}

/// anchor key
fileprivate struct HighlightAnchorKey: PreferenceKey {
    static var defaultValue: [Int: Highlight] = [:]
    
    static func reduce(value: inout [Int: Highlight], nextValue: () -> [Int: Highlight]) {
        value.merge(nextValue()) { $1 }
    }
    
    
}

struct ShowCaseHelper: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ContentView()
}
