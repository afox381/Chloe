import Foundation

protocol ProductListCollectionViewCellViewModelType {
    var title: NSAttributedString { get }
    var price: NSAttributedString { get }
    var imageUrl: URL? { get }
    var isLiked: Bool { get }
}

public struct ProductListCollectionViewCellViewModel: ProductListCollectionViewCellViewModelType {
    let productListItem: ProductListItem
    let isLiked: Bool
    
    enum Constants {
        static let resolution: String = "13" // 240x320
    }
    
    init(with productListItem: ProductListItem, isLiked: Bool) {
        self.productListItem = productListItem
        self.isLiked = isLiked
    }
    
    var title: NSAttributedString {
        productListItem.title.attributed()
    }
    
    var price: NSAttributedString {
        String(productListItem.fullPrice).attributed() // TODO: format price
    }
    
    var imageUrl: URL? {
        let urlString = Url.productImage(folderId: String(productListItem.defaultCode10.prefix(2)),
                                         defaultCode10: productListItem.defaultCode10,
                                         resolution: Constants.resolution)
        return URL(string: urlString)
    }
}
