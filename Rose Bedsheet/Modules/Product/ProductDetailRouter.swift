//
//  ProductDetailRouter.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 6/12/25.
//

import Foundation
import SwiftUI

enum ProductDetailRouterNavigationDestination: Hashable, Equatable {
    case productDetails(id: Int)
    case productReviews(dependencies: ProductReviewsView.Dependencies)
    
    struct OnDone<T>: Equatable, Hashable {
        static func == (lhs: ProductDetailRouterNavigationDestination.OnDone<T>, rhs: ProductDetailRouterNavigationDestination.OnDone<T>) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        var id = UUID().uuidString
        var callback: (_ payload: T) -> Void
    }
}

enum ProductDetailRouterSheetDestination: Hashable, Identifiable {
    case addToCart
    
    struct OnDone<T>: Equatable, Hashable {
        static func == (lhs: ProductDetailRouterSheetDestination.OnDone<T>, rhs: ProductDetailRouterSheetDestination.OnDone<T>) -> Bool {
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
        case .addToCart:
            "addToCart"
        }
    }
}

enum ProductDetailRouterFullScreenDestination: Hashable, Identifiable {
    case productImageViewer
    
    struct OnDone<T>: Equatable, Hashable {
        static func == (lhs: ProductDetailRouterFullScreenDestination.OnDone<T>, rhs: ProductDetailRouterFullScreenDestination.OnDone<T>) -> Bool {
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
        case .productImageViewer:
            "productImageViewer"
        }
    }
}

final class ProductDetailRouter: ObservableObject {
    @Published var path = [ProductDetailRouterNavigationDestination]()
    @Published var currentFullscreenDestination: ProductDetailRouterFullScreenDestination?
    @Published var currentSheetDestination: ProductDetailRouterSheetDestination?
    
    func navigate(to destination: ProductDetailRouterNavigationDestination) {
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
    func withProductDetailFullscreenCover(router: ProductDetailRouter,
                                          destination: Binding<ProductDetailRouterFullScreenDestination?>
    ) -> some View {
        fullScreenCover(item: destination) { destination in
            switch destination {
            case .productImageViewer:
                VStack {
                    
                }
                .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
    
    @ViewBuilder
    func withProductDetailSheetCover(router: ProductDetailRouter,
                                     destination: Binding<ProductDetailRouterSheetDestination?>
    ) -> some View {
        sheet(item: destination) { destination in
            switch destination {
            case .addToCart:
                EmptyView()
            }
        }
    }
    
    @ViewBuilder
    func withProductDetailDestination(router: ProductDetailRouter) -> some View {
        navigationDestination(for: ProductDetailRouterNavigationDestination.self) { destination in
            switch destination {
            case .productDetails(let id):
                ProductDetailView()
                    .toolbar(.hidden, for: .navigationBar)
            case .productReviews(let dependencies):
                ProductReviewsView(dependencies: dependencies)
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}
