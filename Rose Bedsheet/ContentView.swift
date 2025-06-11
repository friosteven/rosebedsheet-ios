//
//  ContentView.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 5/31/25.
//

import SwiftUI
import Common

struct ContentView: View {
    @StateObject private var appRouter = AppRouter()
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        DashboardView()
            .padding()
            .onChange(of: scenePhase, perform: { value in
                switch value {
                case .active:
                    _ = AppConfig.shared
                default:
                    print("")
                }
            })
            .environmentObject(appRouter)
            .globalAlertModifier()
    }
}

#Preview {
    ContentView()
}
