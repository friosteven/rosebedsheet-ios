//
//  ProductDetailView.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 6/12/25.
//

import Foundation
import SwiftUI
import Common

struct ProductDetailView: View {
    @StateObject private var productDetailRouter = ProductDetailRouter()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack(path: $productDetailRouter.path) {
            content
                .withProductDetailDestination(router: productDetailRouter)
                .withProductDetailFullscreenCover(router: productDetailRouter, destination: $productDetailRouter.currentFullscreenDestination)
                .withProductDetailSheetCover(router: productDetailRouter, destination: $productDetailRouter.currentSheetDestination)
        }
    }

    private var content: some View {
        VStack {
            Text("Product Detail View")
            Button {
                dismiss()
            } label: {
                Text("dismiss")
            }
        }
    }
}

// Mock Dependencies and Views for compilable example
struct ProductReviewsView: View {
    struct Dependencies: EquatableHashableStruct {
        // Dependencies for the view, e.g., product ID
        let id = UUID()
    }

    let dependencies: Dependencies

    var body: some View {
        Text("Product Reviews")
    }
}
