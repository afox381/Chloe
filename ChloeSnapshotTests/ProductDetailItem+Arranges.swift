import Foundation
@testable import Chloe

extension ProductDetailItem {
    static func arrange() -> ProductDetailItem {
        let macroCategory = CroCategory(id: 1234, name: "Macro Category")
        let microCategory = CroCategory(id: 5678, name: "Micro Category")
        let descriptions = [
            Description(key: "ModelNames", value: "Product Name", c10: "123"),
            Description(key: "ItemDescription", value: "Product Description", c10: "456"),
            Description(key: "MadeIn", value: "Made In France", c10: "789")
        ]
        let price = Price(discountedPrice: 3000, fullPrice: 5000)
        
        return .init(item: Item(macroCategory: macroCategory,
                                microCategory: microCategory,
                                descriptions: descriptions,
                                price: price))
    }
}
