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
    func fetchCategories() async throws -> Result<[CategoryModel], RequestError>
    func fetchMaterials() async throws -> Result<[MaterialModel], RequestError>
    func fetchDesigns() async throws -> Result<[DesignModel], RequestError>
    func fetchCategoriesWithSizes() async throws -> Result<[CategoriesWithSizesModel], RequestError>
}

class SellerService: SellerServiceProtocol {
    private let colorRepository: GenericRepository<ColorModel>
    private let categoriesRepository: GenericRepository<CategoryModel>
    private let materialsRepository: GenericRepository<MaterialModel>
    private let designsRepository: GenericRepository<DesignModel>
    private let categoriesWithSizesRepository: GenericRepository<CategoriesWithSizesModel>

    init(httpClient: HTTPClient) {
        self.colorRepository = GenericRepository(httpClient: httpClient, path: "/colors")
        self.categoriesRepository = GenericRepository(httpClient: httpClient, path: "/categories")
        self.materialsRepository = GenericRepository(httpClient: httpClient, path: "/materials")
        self.designsRepository = GenericRepository(httpClient: httpClient, path: "/designs")
        self.categoriesWithSizesRepository = GenericRepository(httpClient: httpClient, path: "/rpc/get_categories_with_sizes")
    }

    func fetchColors() async throws -> Result<[ColorModel], RequestError> {
        let params = [URLQueryItem(name: "select", value: "*")]
        return await colorRepository.getAll(params: params)
    }

    func fetchCategories() async throws -> Result<[CategoryModel], RequestError> {
        let params = [URLQueryItem(name: "select", value: "*")]
        return await categoriesRepository.getAll(params: params)
    }

    func fetchMaterials() async throws -> Result<[MaterialModel], RequestError> {
        let params = [URLQueryItem(name: "select", value: "*")]
        return await materialsRepository.getAll(params: params)
    }

    func fetchDesigns() async throws -> Result<[DesignModel], RequestError> {
        let params = [URLQueryItem(name: "select", value: "*")]
        return await designsRepository.getAll(params: params)
    }
    
    func fetchCategoriesWithSizes() async throws -> Result<[CategoriesWithSizesModel], RequestError> {
        return await categoriesWithSizesRepository.getAll()
    }
}
