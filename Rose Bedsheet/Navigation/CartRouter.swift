//
//  CartRouter.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 6/2/25.
//

import Foundation
import SwiftUI

enum CartRouterNavigationDestination: Hashable, Equatable {
    case viewCart
    case checkout(onDone: OnDone<()>)
    
    struct OnDone<T>: Equatable, Hashable {
        static func == (lhs: CartRouterNavigationDestination.OnDone<T>, rhs: CartRouterNavigationDestination.OnDone<T>) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        var id = UUID().uuidString
        var callback: (_ payload: T) -> Void
    }
}

enum CartRouterSheetDestination: Hashable, Identifiable {
    case applyPromoCode(onDone: OnDone<String?>)
    
    struct OnDone<T>: Equatable, Hashable {
        static func == (lhs: CartRouterSheetDestination.OnDone<T>, rhs: CartRouterSheetDestination.OnDone<T>) -> Bool {
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
        case .applyPromoCode:
            "applyPromoCode"
        }
    }
}

enum CartRouterFullScreenDestination: Hashable, Identifiable {
    case shippingAddressForm
    
    struct OnDone<T>: Equatable, Hashable {
        static func == (lhs: CartRouterFullScreenDestination.OnDone<T>, rhs: CartRouterFullScreenDestination.OnDone<T>) -> Bool {
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
        case .shippingAddressForm:
            "shippingAddressForm"
        }
    }
}

final class CartRouter: ObservableObject {
    @Published var path = [CartRouterNavigationDestination]()
    @Published var currentFullscreenDestination: CartRouterFullScreenDestination?
    @Published var currentSheetDestination: CartRouterSheetDestination?
    
    func navigate(to destination: CartRouterNavigationDestination) {
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
    func withCartFullscreenCover(router: CartRouter,
                                 destination: Binding<CartRouterFullScreenDestination?>
    ) -> some View {
        fullScreenCover(item: destination) { destination in
            switch destination {
            case .shippingAddressForm:
                // Replace with your actual ShippingAddressFormView
                Text("Shipping Address Form View")
            }
        }
    }
    
    @ViewBuilder
    func withCartSheetCover(router: CartRouter,
                            destination: Binding<CartRouterSheetDestination?>
    ) -> some View {
        sheet(item: destination) { destination in
            switch destination {
            case .applyPromoCode:
                // Replace with your actual PromoCodeView
                Text("Apply Promo Code View")
            }
        }
    }
    
    @ViewBuilder
    func withCartDestinations(router: CartRouter) -> some View {
        navigationDestination(for: CartRouterNavigationDestination.self) { destination in
            switch destination {
            case .viewCart:
                // Replace with your actual CartView
                Text("Cart View")
            case .checkout:
                // Replace with your actual CheckoutView
                Text("Checkout View")
            }
        }
    }
}
