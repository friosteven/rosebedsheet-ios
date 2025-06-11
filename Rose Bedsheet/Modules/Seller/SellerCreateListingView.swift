//
//  SellerCreateListingView.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 6/7/25.
//

import SwiftUI
import Common

struct SellerCreateListingView: View {
    @State private var productNameText = ""
    @State private var productDescriptionText = ""
    @State private var selectedProductType: String = ""
    @State private var productTypes: [String] = ["Bedsheet", "Pillowcases"]
    
    @State private var priceText = ""
    @State private var quantityText = ""
    
    @StateObject private var viewModel = SellerViewModel()
    var body: some View {
        VStack {
            AppContainerView(title: "Create Listing",
                             config: .navbarConfig,
                             content: {
                VStack(spacing: 24) {
                    AppTextField(
                        text: $productNameText,
                        placeholder: "Product Name",
                        placeholderStyle: .floating)
                    
                    AppTextField(
                        text: $productDescriptionText,
                        placeholder: "Description",
                        type: .multiline(maxLength: 500),
                        placeholderStyle: .floating)
                    
                    AppListView(viewModel.productTypesModel,
                                selectionMode: .multiSelect(limit: 5),
                                scrollDirection: .horizontal,
                                showsIndicators: false,
                                sectionTitle: "Product Type") { value, isSelected in
                        VStack {
                            Text(value.name)
                                .applyTypography(isSelected ? .bodySemiboldLeading : .bodyRegularLeading)
                                .foregroundStyle(isSelected ? AppColors.surface : AppColors.primaryText)
                                .pad(horizontal: 16, vertical: 8)
                        }
                        .background(isSelected ? AppColors.primary : AppColors.border)
                        .cornerRadius(24, corners: .allCorners)
                        .cardStyle(
                            cornerRadius: 24,
                            shadowColor: isSelected ? .black.opacity(0.25) : .clear,
                            shadowY: isSelected ? 8 : 0,
                            borderColor: isSelected ? .black.opacity(0.5) : .clear,
                            borderWidth: isSelected ? 2 : 0
                        )
                        .pad(horizontal: 4, vertical: 12)
                    }
                    
                    AppFlowLayoutView(viewModel.fabricsModel,
                                      selectionMode: .singleSelect,
                                      verticalSpacing: 0,
                                      sectionTitle: "Fabric Type") { value, isSelected in
                        VStack {
                            Text(value.name)
                                .applyTypography(isSelected ? .bodySemiboldLeading : .bodyRegularLeading)
                                .foregroundStyle(isSelected ? AppColors.surface : AppColors.primaryText)
                                .pad(horizontal: 16, vertical: 8)
                        }
                        .background(isSelected ? AppColors.primary : AppColors.border)
                        .cornerRadius(24, corners: .allCorners)
                        .cardStyle(
                            cornerRadius: 24,
                            shadowColor: isSelected ? .black.opacity(0.25) : .clear,
                            shadowY: isSelected ? 8 : 0,
                            borderColor: isSelected ? .black.opacity(0.5) : .clear,
                            borderWidth: isSelected ? 2 : 0
                        )
                        .pad(horizontal: 4, vertical: 8)
                    }
                    
                    AppListView(viewModel.colorsModel,
                                selectionMode: .multiSelect(limit: 5),
                                scrollDirection: .horizontal,
                                showsIndicators: false,
                                sectionTitle: "Color") { value, isSelected in
                        Circle()
                            .fill(Color(hex: value.hex))
                            .frame(width: 48, height: 48)
                            .cardStyle(
                                cornerRadius: 24,
                                shadowColor: isSelected ? .black.opacity(0.25) : .clear,
                                shadowY: isSelected ? 8 : 0,
                                borderColor: isSelected ? .black.opacity(0.75) : .clear,
                                borderWidth: isSelected ? 2 : 0
                            )
                            .pad(horizontal: 4, vertical: 12)
                    }
                    
                    AppTextField(
                        text: $priceText,
                        placeholder: "Price",
                        placeholderStyle: .floating)
                    
                    AppTextField(
                        text: $quantityText,
                        placeholder: "Stock Quantity",
                        placeholderStyle: .floating)
                }
                .pad(horizontal: 16, vertical: 20)
            })
            
            
            HStack(spacing: 16) {
                AppButton("Save as draft", config: .init(style: .outlineAffirm)) {
                    
                }
                
                AppButton("Submit") {
                }
            }
            .frame(height: 48)
            .pad(horizontal: 16, vertical: 16)
        }
        .background(AppColors.inputBackground)
        .task {
            await viewModel.fetchColors()
            await viewModel.fetchProductTypes()
            await viewModel.fetchFabrics()
        }
    }
}

#Preview {
    SellerCreateListingView()
}
