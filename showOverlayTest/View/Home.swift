//
//  Home.swift
//  showOverlayTest
//
//  Created by Bryan Vernanda on 28/10/24.
//

import SwiftUI
import MapKit

struct Home: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090),
        latitudinalMeters: 1000,
        longitudinalMeters: 1000
    )
    
    @State private var isNavigate: Bool = false
    @State private var changeShowState: Condition = .hide
    
    var body: some View {
        NavigationStack {
            ZStack {
                TabView {
                    GeometryReader {
                        let safeArea = $0.safeAreaInsets
                        
                        Map(coordinateRegion: $region)
                        /// Top safe area mateial view
                            .overlay(alignment: .top, content: {
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                                    .frame(height: safeArea.top)
                            })
                            .ignoresSafeArea()
                            .overlay(alignment: .topTrailing) {
                                VStack {
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "location.fill")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background{
                                                RoundedRectangle(cornerRadius: 10, style:
                                                        .continuous)
                                                .fill(.black)
                                            }
                                    }
                                    .showCase(
                                        order: 0,
                                        title: "My Current Location",
                                        cornerRadius: 10,
                                        style: .continuous
                                    )
                                    
                                    Spacer(minLength: 0)
                                    
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "suit.heart.fill")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background{
                                                RoundedRectangle(cornerRadius: 10, style:
                                                        .continuous)
                                                .fill(.red)
                                            }
                                    }
                                    .showCase(
                                        order: 1,
                                        title: "Favorite Location's",
                                        cornerRadius: 10,
                                        style: .continuous,
                                        showState: .show
                                    )
                                }
                                .padding(15)
                            }
                    }
                    .tabItem {
                        Image(systemName: "macbook.and.iphone")
                        Text("Devices")
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                    
                    Text("")
                        .tabItem {
                            Image(systemName: "square.grid.2x2.fill")
                            Text("Items")
                        }
                    
                    Text("")
                        .tabItem {
                            Image(systemName: "person.circle.fill")
                            Text("Me")
                        }
                }
                .overlay(alignment: .bottom, content: {
                    HStack(spacing: 0) {
                        Circle()
                            .foregroundColor(.clear)
                            .frame(width: 45, height: 45)
                            .showCase(
                                order: 2,
                                title: "My Devices",
                                cornerRadius: 10,
                                style: .continuous
                            )
                            .frame(maxWidth: .infinity)
                        
                        Circle()
                            .foregroundColor(.clear)
                            .frame(width: 45, height: 45)
                            .showCase(
                                order: 4,
                                title: "Location Enabled Tag's",
                                cornerRadius: 10,
                                style: .continuous
                            )
                            .frame(maxWidth: .infinity)
                        
                        Circle()
                            .foregroundColor(.clear)
                            .frame(width: 45, height: 45)
                            .showCase(
                                order: 3,
                                title: "Personal Info",
                                cornerRadius: 10,
                                style: .continuous,
                                showState: .show
                            )
                            .frame(maxWidth: .infinity)
                    }
                    /// disabling user interactions
                    .allowsHitTesting(false)
                })
                /// Call this modifier on the top of the current view, also it must be called once
                .modifier(ShowCaseRoot(showHighlights: true, changeShowState: changeShowState, onFinished: { value in
                    if changeShowState == .show {
                        isNavigate = !value
                    } else {
                        isNavigate = value
                    }
                }))
            }
            .navigationDestination(isPresented: $isNavigate) {
                Home2(changeShowState: $changeShowState)
            }
        }

    }

}


#Preview {
    Home()
}
