//
//  ColorModel.swift
//  Rose Bedsheet
//
//  Created by John Steven Frio on 6/11/25.
//

import Foundation

// MARK: - ColorModel
struct ColorModel: Codable, Identifiable, Hashable {
    let id: Int
    let name, hex: String
}

// MARK: - CategoryModel
struct CategoryModel: Codable, Identifiable, Hashable {
    let id: Int
    let name, type: String
}

// MARK: - MaterialModel
struct MaterialModel: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let key: String
}

// MARK: - DesignModel
struct DesignModel: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let key: String
}


// MARK: - CategoriesWithSizesModel
struct CategoriesWithSizesModel: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let type: String
    let sizes: [SizeModel]
}

// MARK: - SizeModel
struct SizeModel: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let width: Int
    let length: Int
}
