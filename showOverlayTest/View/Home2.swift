//
//  Home2.swift
//  showOverlayTest
//
//  Created by Bryan Vernanda on 29/10/24.
//

import SwiftUI

struct Home2: View {
    @Binding var changeShowState: Condition
    @State private var isNavigateToHome3 = false  // For navigating to Home3
    @Environment(\.dismiss) private var dismiss  // To dismiss Home2

    var body: some View {
        ZStack {
            VStack {
                Button {
                    isNavigateToHome3 = true
                } label: {
                    Text("Navigate to Home3")
                }
                
                Button {
                    changeShowState = .show
                    dismiss()
                } label: {
                    Text("Dismiss Home2")
                }
            }
            .navigationDestination(isPresented: $isNavigateToHome3) {
                Home3(changeShowState: $changeShowState, isNavigateBackToHome2: $isNavigateToHome3)
            }
        }
    }
}


#Preview {
    Home2(changeShowState: .constant(.hide))
}
