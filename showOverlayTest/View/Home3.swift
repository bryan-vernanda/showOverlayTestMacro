//
//  Home3.swift
//  showOverlayTest
//
//  Created by Bryan Vernanda on 29/10/24.
//

import SwiftUI

struct Home3: View {
    @Binding var changeShowState: Condition
    @Binding var isNavigateBackToHome2: Bool  // This controls navigation back to Home2

    var body: some View {
        VStack {
            Button {
                isNavigateBackToHome2 = false  // Programmatically navigate back to Home2
            } label: {
                Text("Dismiss Home3")
            }
            .padding(.top, 20)
        }
    }
}



#Preview {
    Home3(changeShowState: .constant(.hide), isNavigateBackToHome2: .constant(false))
}
