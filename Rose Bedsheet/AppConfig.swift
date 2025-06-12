//
//  AppConfig.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 6/10/25.
//

import Foundation
import Common
import SwiftUI
#if canImport(netfox)
import netfox
#endif

struct AppConfig {
    static let shared = AppConfig()
    
    init() {
    #if canImport(netfox)
            NFX.sharedInstance().start()
    #endif
    }
}

struct AppConfigViewModifier: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase
    
    func body(content: Content) -> some View {
        content
            .globalAlertModifier()
            .onChange(of: scenePhase) { newValue in
                switch newValue {
                case .active:
                    _ = AppConfig.shared
                default:
                    print("")
                }
            }
        /// Add necessary view modifiers here.
    }
}


extension View {
    /// Only call this on the root view of the app, if possible.
    func inititalizeApp() -> some View {
        modifier(AppConfigViewModifier())
    }
}
