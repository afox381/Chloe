import Foundation

protocol ProductListTableViewCellViewModelType {
    var name: String { get }
    var nickname: String { get }
    var portrayed: String { get }
    var imageUrl: URL? { get }
    var isLiked: Bool { get }
}

public struct ProductListTableViewCellViewModel: ProductListTableViewCellViewModelType {
    let productItem: ProductListItem
    let isLiked: Bool
    
    var name: String { productItem.name }
    var nickname: String { productItem.nickname }
    var portrayed: String { productItem.portrayed }
    var imageUrl: URL? { URL(string: productItem.img) }
    
    init(with productItem: ProductListItem, isLiked: Bool) {
        self.productItem = productItem
        self.isLiked = isLiked
    }
}
