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
    @Published private(set) var productTypesModel: [ProductTypeModel] = []
    @Published private(set) var fabricsModel: [FabricModel] = []
    @Published private(set) var designTypesModel: [DesignTypeModel] = []
    
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
    func fetchProductTypes() async {
        do {
            productTypesModel = try await sellerService.fetchProductTypes().get()
        } catch {
            
        }
    }
    
    @MainActor
    func fetchFabricTypes() async {
        do {
            fabricsModel = try await sellerService.fetchFabricTypes().get()
        } catch {
            
        }
    }
    
    @MainActor
    func fetchDesignTypes() async {
        do {
            designTypesModel = try await sellerService.fetchDesignTypes().get()
        } catch {
            
        }
    }
}
