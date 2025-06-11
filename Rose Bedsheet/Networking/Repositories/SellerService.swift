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
    func fetchFabrics() async throws -> Result<[FabricModel], RequestError>
}

class SellerService: SellerServiceProtocol {
    private let colorRepository: GenericRepository<ColorModel>
    private let productTypeRepository: GenericRepository<ProductTypeModel>
    private let fabricRepository: GenericRepository<FabricModel>

    init(httpClient: HTTPClient) {
        self.colorRepository = GenericRepository(httpClient: httpClient, path: "/rpc/get_colors")
        self.productTypeRepository = GenericRepository(httpClient: httpClient, path: "/rpc/get_product_types")
        self.fabricRepository = GenericRepository(httpClient: httpClient, path: "/rpc/get_fabrics")
    }

    func fetchColors() async throws -> Result<[ColorModel], RequestError> {
        return await colorRepository.getAll()
    }

    func fetchProductTypes() async throws -> Result<[ProductTypeModel], RequestError> {
        return await productTypeRepository.getAll()
    }

    func fetchFabrics() async throws -> Result<[FabricModel], RequestError> {
        return await fabricRepository.getAll()
    }
}
