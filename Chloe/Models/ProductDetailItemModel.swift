import Foundation

struct ProductDetailItem: Codable {
    let quoteID: Int
    let quote: String
    let author: String
    
    enum CodingKeys: String, CodingKey {
        case quoteID = "quote_id"
        case quote, author
    }
}
