//
//  CartRouter.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 6/2/25.
//

import Foundation
import SwiftUI

class CartRouter: ObservableObject {
    @Published var path = [NavigationPath()]
}

enum CartRouterNavDestination: Hashable, Equatable {
    case cart
    
    struct OnDone<T>: Equatable, Hashable {
        static func == (lhs: CartRouterNavDestination.OnDone<T>,
                        rhs: CartRouterNavDestination.OnDone<T>) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        var id = UUID()
        var callback: (_ payload: T) -> Void
    }
}

enum CartRouterFullScreenDestination: Hashable, Identifiable {
    case item
    
    struct OnDone<T>: Equatable, Hashable {
        static func == (lhs: CartRouterFullScreenDestination.OnDone<T>,
                        rhs: CartRouterFullScreenDestination.OnDone<T>) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        var id = UUID()
        var callback: (_ payload: T) -> Void
    }
    
    var id: String {
        return self.hashValue.description
    }
}

//TODO: CREATE SOMETHING FOR SHEET TOO

extension View {
    func withFullScreenCover(router: CartRouter,
                             destination: Binding<CartRouterFullScreenDestination?>) -> some View {
        fullScreenCover(item: destination) { destination in
            switch destination {
            default:
                EmptyView()
            }
        }
    }
}
