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
    var body: some View {
        VStack(spacing: 40) {
            AppButton("Create New Listing",
                      config: .init(style: .affirm,
                                    icon: UIImage(systemName: "plus"), typography: .bodyRegularCenter)) {
                
            }.frame(height: 50)
            
            AppListView(items,
                        sectionTitle: "My Listed Items",
                        sectionNavTitle: "View All",
                        content: { item, isSelected in
                let config = AppCellTypographyConfiguration(
                    titleTypography: .bodySemiboldLeading,
                    titleColor: AppColors.primaryText,
                    subTitleTypography: .bodyRegularLeading,
                    subtitleColor: AppColors.secondaryText)
                Button {
                    
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
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(AppColors.surface)
    }
}

#Preview {
    SellerDashboardView()
}
