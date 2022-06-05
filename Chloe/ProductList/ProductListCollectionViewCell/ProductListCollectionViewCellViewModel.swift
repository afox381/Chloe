import Foundation

protocol ProductListCollectionViewCellViewModelType {
    var title: NSAttributedString { get }
    var price: NSAttributedString { get }
    var imageUrl: URL? { get }
    var isLiked: Bool { get }
}

public struct ProductListCollectionViewCellViewModel: ProductListCollectionViewCellViewModelType {
    let productListItem: ProductListItem
    let imageResolution: String
    let isLiked: Bool
    
    init(productListItem: ProductListItem,
         imageResolution: String,
         isLiked: Bool) {
        self.productListItem = productListItem
        self.imageResolution = imageResolution
        self.isLiked = isLiked
    }
    
    var title: NSAttributedString {
        productListItem.title.attributed()
            .applyFont(.listTitle)
            .applyForegroundColor(.black)
    }
    
    var price: NSAttributedString {
        productListItem.fullPrice.formattedPrice().attributed()
            .applyFont(.listPrice)
            .applyForegroundColor(.black)
    }
    
    var imageUrl: URL? {
        let urlString = Url.productImage(folderId: String(productListItem.defaultCode10.prefix(2)),
                                         defaultCode10: productListItem.defaultCode10,
                                         resolution: imageResolution)
        return URL(string: urlString)
    }
}
