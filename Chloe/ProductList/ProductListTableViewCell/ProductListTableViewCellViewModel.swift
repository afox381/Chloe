import Foundation

protocol ProductListTableViewCellViewModelType {
    var title: NSAttributedString { get }
    var price: NSAttributedString { get }
    var imageUrl: URL? { get }
    var isLiked: Bool { get }
}

public struct ProductListTableViewCellViewModel: ProductListTableViewCellViewModelType {
    let productItem: ProductListItem
    let isLiked: Bool
    
    init(with productItem: ProductListItem, isLiked: Bool) {
        self.productItem = productItem
        self.isLiked = isLiked
    }
    
    var title: NSAttributedString {
        productItem.title.attributed()
    }
    
    var price: NSAttributedString {
        String(productItem.fullPrice).attributed() // TODO: format price
    }
    
    var imageUrl: URL? {
        let urlString = Url.productImage(folderId: String(productItem.defaultCode10.prefix(2)),
                                         defaultCode10: productItem.defaultCode10,
                                         resolution: "8")
        return URL(string: urlString)
    }
}
