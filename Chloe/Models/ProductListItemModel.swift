import Foundation

struct ProductList: Codable {
    let resultsLite: ResultsLite

    enum CodingKeys: String, CodingKey {
        case resultsLite = "ResultsLite"
    }
}

struct ResultsLite: Codable {
    let items: [ProductListItem]

    enum CodingKeys: String, CodingKey {
        case items = "Items"
    }
}

struct ProductListItem: Codable {
    let code8: String
    let defaultCode10: String
    let title: String
    let fullPrice: Int

    enum CodingKeys: String, CodingKey {
        case code8 = "Code8"
        case defaultCode10 = "DefaultCode10"
        case title = "ModelNames"
        case fullPrice = "FullPrice"
    }
}


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let characterless = try? newJSONDecoder().decode(Characterless.self, from: jsonData)

//import Foundation
//
//// MARK: - Characterless
//struct ProductList: Codable {
//    let header: Header
//    let resultsLite: ResultsLite
//
//    enum CodingKeys: String, CodingKey {
//        case header = "Header"
//        case resultsLite = "ResultsLite"
//    }
//}
//
//// MARK: - Header
//struct Header: Codable {
//    let statusCode: Int
//    let headerDescription: String
//
//    enum CodingKeys: String, CodingKey {
//        case statusCode = "StatusCode"
//        case headerDescription = "Description"
//    }
//}
//
//// MARK: - ResultsLite
//struct ResultsLite: Codable {
//    let totalResults: Int
//    let items: [ProductListItem]
//
//    enum CodingKeys: String, CodingKey {
//        case totalResults = "TotalResults"
//        case items = "Items"
//    }
//}
//
//// MARK: - Item
//struct ProductListItem: Codable {
//    let code8, brandName, defaultCode10, microCategory: String
//    let macroCategory, alternativeMicro: String
//    let fullPrice, discountedPrice: Int
//    let modelNames: String
//    let sizes: [Size]
//    let colors: [Color]
//
//    enum CodingKeys: String, CodingKey {
//        case code8 = "Code8"
//        case brandName = "BrandName"
//        case defaultCode10 = "DefaultCode10"
//        case microCategory = "MicroCategory"
//        case macroCategory = "MacroCategory"
//        case alternativeMicro = "AlternativeMicro"
//        case fullPrice = "FullPrice"
//        case discountedPrice = "DiscountedPrice"
//        case modelNames = "ModelNames"
//        case sizes = "Sizes"
//        case colors = "Colors"
//    }
//}
//
//// MARK: - Color
//struct Color: Codable {
//    let id: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id = "Id"
//    }
//}
//
//// MARK: - Size
//struct Size: Codable {
//    let text, classFamily: String
//
//    enum CodingKeys: String, CodingKey {
//        case text = "Text"
//        case classFamily = "ClassFamily"
//    }
//}
