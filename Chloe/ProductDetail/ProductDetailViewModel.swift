import UIKit
import Combine

protocol ProductDetailViewDelegate: AnyObject {
    func productDetailViewDidToggleLike(_ id: String)
}

protocol ProductDetailViewModelType {
    var name: String { get }
    var occupation: [String] { get }
    var status: String { get }
    var image: UIImage? { get }
    var isLiked: Bool { get }
    
    func fetchProductDetails() -> AnyPublisher<AsyncState<[ProductDetailItem]?>, Never>
    func toggleLike()
}

struct ProductDetailViewModel: ProductDetailViewModelType {
    let id: String
    let name: String
    let occupation: [String]
    let status: String
    let image: UIImage?
    let productDetailRepository: ProductDetailRepository
    let likesRepository: LikesRepository
    weak var delegate: ProductDetailViewDelegate?

    var isLiked: Bool {
        likesRepository.isLiked(id)
    }

    func fetchProductDetails() -> AnyPublisher<AsyncState<[ProductDetailItem]?>, Never> {
        productDetailRepository.fetchProductDetail(productId: id)
    }
    
    func toggleLike() {
        likesRepository.toggleLike(id)
        delegate?.productDetailViewDidToggleLike(id)
    }
}
