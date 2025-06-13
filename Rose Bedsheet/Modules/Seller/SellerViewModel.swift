//
//  SellerViewModel.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 6/10/25.
//

import Foundation
import Common

class SellerViewModel: ObservableObject {
    @Published private(set) var colorsModel: [ColorModel] = []
    @Published private(set) var categoriesModel: [CategoryModel] = []
    @Published private(set) var materialsModel: [MaterialModel] = []
    @Published private(set) var designsModel: [DesignModel] = []
    @Published private(set) var categoriesWithSizesModel: [CategoriesWithSizesModel] = []
    
    @Published var sizesBasedOnSelectedCategory: [SizeModel] = []
    
    @Published private var sellerService: SellerService
    
    init(httpClient: HTTPClient = ProjectNetworkConfig.shared.getSupabaseHTTPClient()
    ) {
        self.sellerService = SellerService(httpClient: httpClient)
    }
    
    @MainActor
    func fetchColors() async {
        do {
            colorsModel = try await sellerService.fetchColors().get()
        } catch {
            
        }
    }
    
    @MainActor
    func fetchCategories() async {
        do {
            categoriesModel = try await sellerService.fetchCategories().get()
        } catch {
            
        }
    }
    
    @MainActor
    func fetchMaterials() async {
        do {
            materialsModel = try await sellerService.fetchMaterials().get()
        } catch {
            
        }
    }
    
    @MainActor
    func fetchDesigns() async {
        do {
            designsModel = try await sellerService.fetchDesigns().get()
        } catch {
            
        }
    }
    
    @MainActor
    func fetchCategoriesWithSizes() async {
        do {
            categoriesWithSizesModel = try await sellerService.fetchCategoriesWithSizes().get()
        } catch {
            
        }
    }
    
    func setSizesBasedOnSelectedCategory(selectedCategory: CategoriesWithSizesModel) {
        sizesBasedOnSelectedCategory = categoriesWithSizesModel.filter({
            $0.name == selectedCategory.name
        }).first?.sizes ?? []
    }
}
