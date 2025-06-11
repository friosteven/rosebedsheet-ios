//
//  SellerRouter.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 6/11/25.
//

import Foundation
import SwiftUI

enum SellerRouterNavigationDestination: Hashable, Equatable {
    case sellerDashboard(onDone: OnDone<()>)
    case sellerForm(onDone: OnDone<()>)
    
    struct OnDone<T>: Equatable, Hashable {
        static func == (lhs: SellerRouterNavigationDestination.OnDone<T>, rhs: SellerRouterNavigationDestination.OnDone<T>) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        var id = UUID().uuidString
        var callback: (_ payload: T) -> Void
    }
}

enum SellerRouterSheetDestination: Hashable, Identifiable {
    case payment
    
    struct OnDone<T>: Equatable, Hashable {
        static func == (lhs: SellerRouterSheetDestination.OnDone<T>, rhs: SellerRouterSheetDestination.OnDone<T>) -> Bool {
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
        case .payment:
            "payment"
        }
    }
}

enum SellerRouterFullScreenDestination: Hashable, Identifiable {
    case onlinePayment(paymentUrl: URL, onDone: OnDone<Void>)
    
    struct OnDone<T>: Equatable, Hashable {
        static func == (lhs: SellerRouterFullScreenDestination.OnDone<T>, rhs: SellerRouterFullScreenDestination.OnDone<T>) -> Bool {
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
        case .onlinePayment:
            "onlinePayment"
        }
    }
}

final class SellerRouter: ObservableObject {
    @Published var path = [SellerRouterNavigationDestination]()
    @Published var currentFullscreenDestination: SellerRouterFullScreenDestination?
    @Published var currentSheetDestination: SellerRouterSheetDestination?
    
    func navigate(to destination: SellerRouterNavigationDestination) {
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
    func withFullscreenCover(router: SellerRouter,
                             destination: Binding<SellerRouterFullScreenDestination?>
    ) -> some View {
        fullScreenCover(item: destination) { destination in
            switch destination {
            default:
                EmptyView()
            }
        }
    }
    
    @ViewBuilder
    func withSheetCover(router: SellerRouter,
                        destination: Binding<SellerRouterSheetDestination?>
    ) -> some View {
        sheet(item: destination) { destination in
            switch destination {
            case .payment:
                EmptyView()
            }
        }
    }
    
    @ViewBuilder
    func withAppRouter(router: SellerRouter) -> some View {
        navigationDestination(for: SellerRouterNavigationDestination.self) { destination in
            switch destination {
            case .sellerDashboard:
                SellerDashboardView()
                    .toolbar(.hidden, for: .navigationBar)
            case .sellerForm:
                SellerCreateListingView()
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}
