//
//  Highlight.swift
//  showOverlayTest
//
//  Created by Bryan Vernanda on 28/10/24.
//

import SwiftUI

///Highlight view properties
struct Highlight: Identifiable, Equatable, Hashable {
    var id: UUID = .init()
    var anchor: Anchor<CGRect>
    var title: String
    var cornerRadius: CGFloat
    var style: RoundedCornerStyle = .continuous
    var scale: CGFloat = 1
    let showState: Condition
}

