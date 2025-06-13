//
//  SellerDashboardView.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 6/3/25.
//

import SwiftUI
import Common

struct SellerItems: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let price: Double
    let image: String?
    //TODO: TAGS
}

struct SellerDashboardView: View {
    @State private var items: [SellerItems] = [
         SellerItems(name: "Secure Document", price: 10.00, image: "doc.text.lock.fill"),
         SellerItems(name: "Cloud Storage Plan", price: 25.50, image: "cloud.circle.fill"),
         SellerItems(name: "Navigation Tool", price: 350.00, image: "map.fill"),
         SellerItems(name: "Productivity Suite", price: 15.75, image: "slider.horizontal.3"),
         SellerItems(name: "Data Analytics Report", price: 45.00, image: "chart.bar.xaxis"),
         SellerItems(name: "Gift Card", price: 50.00, image: "giftcard.fill"),
         SellerItems(name: "Settings Cog", price: 5.00, image: nil) // Example with no image (will use default placeholder)
     ]
    
    @StateObject private var sellerRouter = SellerRouter()
    @State private var isShowingProductDetails: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        NavigationStack(path: $sellerRouter.path) {
            content
                .pad(horizontal: 16, vertical: 20)
            .withSellerDestination(router: sellerRouter)
            .withSellerFullscreenCover(router: sellerRouter, destination: $sellerRouter.currentFullscreenDestination)
            .withSellerSheetCover(router: sellerRouter, destination: $sellerRouter.currentSheetDestination)
        }
    }
    
    private var content: some View {
        VStack(spacing: 40) {
            AppButton("Create New Listing",
                      config: .init(style: .affirm,
                                    icon: UIImage(systemName: "plus"), typography: .bodyRegularCenter)) {
                let dependencies = SellerCreateListingView.Dependencies(
                    onTapSaveAsDraft: { value in
                        print("will this work: \(value)")
                        dismiss()
                    }, onTapSubmit: {
                        isShowingProductDetails = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                sellerRouter.reset()
                        })
                    })
                sellerRouter.navigate(to: .sellerCreateListing(dependencies: dependencies))
            }.frame(height: 50)
            
            AppListView(items,
                        sectionTitle: "My Listed Items",
                        sectionNavTitle: "View All",
                        content: { item, selectedItems, isSelected in
                let config = AppCellTypographyConfiguration(
                    titleTypography: .bodySemiboldLeading,
                    titleColor: AppColors.primaryText,
                    subTitleTypography: .bodyRegularLeading,
                    subtitleColor: AppColors.secondaryText)
                Button {
                    isShowingProductDetails = true
                } label: {
                    AppCell(title: item.name,
                            subTitle: String(item.price),
                            typographyConfig: config,
                            leftView: {
                        Image(systemName: item.image ?? "")
                    })
                }.cardStyle()
            })
            Spacer()
        }
        .fullScreenCover(isPresented: $isShowingProductDetails, content: {
            ProductDetailView()
        })
    }
}

#Preview {
    SellerDashboardView()
}
