import Foundation
import Combine

protocol ProductListViewModelType {
    var title: String { get }
    var loadFailureTitle: NSAttributedString { get }
    var loadFailureRetry: NSAttributedString { get }
    
    func fetchProductList() -> AnyPublisher<AsyncState<ProductList?>, Never>
    func isLiked(productId: String) -> Bool
}

struct ProductListViewModel: ProductListViewModelType {
    let title: String
    let category: String
    let productListRepository: ProductListRepository
    let likesRepository: LikesRepository
    
    func fetchProductList() -> AnyPublisher<AsyncState<ProductList?>, Never> {
        productListRepository.fetchProductList(category: category)
    }
    
    func isLiked(productId: String) -> Bool {
        likesRepository.isLiked(productId)
    }
    
    var loadFailureTitle: NSAttributedString {
        "Load Failed".attributed() // TODO: Localisation
            .applyFont(Font.loadFailureTitle)
            .applyForegroundColor(.black)
    }
    
    var loadFailureRetry: NSAttributedString {
        "Retry".attributed()
            .applyFont(Font.loadFailureRetry)
            .applyForegroundColor(.black)
            .applyUnderline()
    }
}
