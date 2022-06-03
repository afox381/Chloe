import Foundation
import Combine

protocol ProductListViewModelType {
    var title: String { get }
    
    func fetchProductList() -> AnyPublisher<AsyncState<[ProductListItem]?>, Never>
    func isLiked(productId: String) -> Bool
}

struct ProductListViewModel: ProductListViewModelType {
    let title: String
    let category: String
    let productListRepository: ProductListRepository
    let likesRepository: LikesRepository
    
    func fetchProductList() -> AnyPublisher<AsyncState<[ProductListItem]?>, Never> {
        productListRepository.fetchProductList(category: category)
    }
    
    func isLiked(productId: String) -> Bool {
        likesRepository.isLiked(productId)
    }
}
