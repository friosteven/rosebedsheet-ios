//
//  ProfileRouter.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 6/12/25.
//
import Foundation
import SwiftUI

enum ProfileRouterNavigationDestination: Hashable, Equatable {
    case viewProfile
    case orderHistory
    case accountSettings
    
    struct OnDone<T>: Equatable, Hashable {
        static func == (lhs: ProfileRouterNavigationDestination.OnDone<T>, rhs: ProfileRouterNavigationDestination.OnDone<T>) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        var id = UUID().uuidString
        var callback: (_ payload: T) -> Void
    }
}

enum ProfileRouterSheetDestination: Hashable, Identifiable {
    case editName
    
    struct OnDone<T>: Equatable, Hashable {
        static func == (lhs: ProfileRouterSheetDestination.OnDone<T>, rhs: ProfileRouterSheetDestination.OnDone<T>) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        var id = UUID().uuidString
        var callback: (_ payload: T) -> Void
        
    }
    
    var id: String {
        switch self {
        case .editName:
            "editName"
        }
    }
}

enum ProfileRouterFullScreenDestination: Hashable, Identifiable {
    case todo
    
    struct OnDone<T>: Equatable, Hashable {
        static func == (lhs: ProfileRouterFullScreenDestination.OnDone<T>, rhs: ProfileRouterFullScreenDestination.OnDone<T>) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        var id = UUID().uuidString
        var callback: (_ payload: T) -> Void
        
    }
    
    var id: String {
        switch self {
        case .todo:
            "todo"
        }
    }
}

final class ProfileRouter: ObservableObject {
    @Published var path = [ProfileRouterNavigationDestination]()
    @Published var currentFullscreenDestination: ProfileRouterFullScreenDestination?
    @Published var currentSheetDestination: ProfileRouterSheetDestination?
    
    func navigate(to destination: ProfileRouterNavigationDestination) {
        path.append(destination)
    }
    
    func back() {
        _ = path.popLast()
    }
    
    func reset() {
        path = []
    }
}

extension View {
    @ViewBuilder
    func withProfileFullscreenCover(router: ProfileRouter,
                                    destination: Binding<ProfileRouterFullScreenDestination?>
    ) -> some View {
        fullScreenCover(item: destination) { destination in
            switch destination {
            default:
                EmptyView()
            }
        }
    }
    
    @ViewBuilder
    func withProfileSheetCover(router: ProfileRouter,
                               destination: Binding<ProfileRouterSheetDestination?>
    ) -> some View {
        sheet(item: destination) { destination in
            switch destination {
            case .editName:
                EditNameView()
            }
        }
    }
    
    @ViewBuilder
    func withProfileDestinations(router: ProfileRouter) -> some View {
        navigationDestination(for: ProfileRouterNavigationDestination.self) { destination in
            switch destination {
            case .viewProfile:
                ProfileView()
            case .orderHistory:
                OrderHistoryView()
            case .accountSettings:
                AccountSettingsView()
            }
        }
    }
}
