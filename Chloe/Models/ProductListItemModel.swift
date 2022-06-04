import Foundation

struct ProductList: Codable {
    let resultsLite: ResultsLite

    enum CodingKeys: String, CodingKey {
        case resultsLite = "ResultsLite"
    }
}

struct ResultsLite: Codable {
    let totalResults: Int
    let items: [ProductListItem]

    enum CodingKeys: String, CodingKey {
        case totalResults = "TotalResults"
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
