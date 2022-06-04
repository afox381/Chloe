import Foundation

struct ProductDetailItem: Codable {
    let item: Item
    
    enum CodingKeys: String, CodingKey {
        case item = "Item"
    }
}

extension ProductDetailItem {
    var name: String { item.descriptions.first(where: { $0.key == "ModelNames" })?.value ?? "" }
    var price: String { item.price.fullPrice.formattedPrice() }
    var macroCategory: String { item.macroCategory.name }
    var microCategory: String { item.microCategory.name }
    var description: String { item.descriptions.first(where: { $0.key == "ItemDescription" })?.value ?? "" }
    var madeIn: String { item.descriptions.first(where: { $0.key == "MadeIn" })?.value ?? "" }
}

struct Item: Codable {
    let macroCategory: CroCategory
    let microCategory: CroCategory
    let descriptions: [Description]
    let price: Price // Required
    
    enum CodingKeys: String, CodingKey {
        case macroCategory = "MacroCategory"
        case microCategory = "MicroCategory"
        case descriptions = "Descriptions"
        case price = "Price"
    }
}

// MARK: - Description
struct Description: Codable {
    let key, value: String
    let c10: String?
    
    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case value = "Value"
        case c10 = "C10"
    }
}

// MARK: - CroCategory
struct CroCategory: Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
}

// MARK: - Price
struct Price: Codable {
    let discountedPrice, fullPrice: Int
    
    enum CodingKeys: String, CodingKey {
        case discountedPrice = "DiscountedPrice"
        case fullPrice = "FullPrice"
    }
}
