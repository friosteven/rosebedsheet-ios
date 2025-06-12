//
//  SellerService.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 6/10/25.
//

import Foundation
import Common

protocol SellerServiceProtocol {
    func fetchColors() async throws -> Result<[ColorModel], RequestError>
    func fetchProductTypes() async throws -> Result<[ProductTypeModel], RequestError>
    func fetchFabricTypes() async throws -> Result<[FabricModel], RequestError>
    func fetchDesignTypes() async throws -> Result<[DesignTypeModel], RequestError>
}

class SellerService: SellerServiceProtocol {
    private let colorRepository: GenericRepository<ColorModel>
    private let productTypeRepository: GenericRepository<ProductTypeModel>
    private let fabricRepository: GenericRepository<FabricModel>
    private let designTypeRepository: GenericRepository<DesignTypeModel>

    init(httpClient: HTTPClient) {
        self.colorRepository = GenericRepository(httpClient: httpClient, path: "/rpc/get_colors")
        self.productTypeRepository = GenericRepository(httpClient: httpClient, path: "/rpc/get_product_types")
        self.fabricRepository = GenericRepository(httpClient: httpClient, path: "/rpc/get_fabric_types")
        self.designTypeRepository = GenericRepository(httpClient: httpClient, path: "/rpc/get_design_types")
    }

    func fetchColors() async throws -> Result<[ColorModel], RequestError> {
        return await colorRepository.getAll()
    }

    func fetchProductTypes() async throws -> Result<[ProductTypeModel], RequestError> {
        return await productTypeRepository.getAll()
    }

    func fetchFabricTypes() async throws -> Result<[FabricModel], RequestError> {
        return await fabricRepository.getAll()
    }

    func fetchDesignTypes() async throws -> Result<[DesignTypeModel], RequestError> {
        return await designTypeRepository.getAll()
    }
}
