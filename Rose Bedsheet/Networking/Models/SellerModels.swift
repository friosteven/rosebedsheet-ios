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

// MARK: - ProductTypeModel
struct ProductTypeModel: Codable, Identifiable, Hashable {
    let id: Int
    let name, type: String
}

// MARK: - FabricModel
struct FabricModel: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let key: String
}

// MARK: - DesignTypeModel
struct DesignTypeModel: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let key: String
}
