import UIKit
import Combine

protocol ProductDetailViewDelegate: AnyObject {
    func productDetailViewDidToggleLike(_ id: String)
}

protocol ProductDetailViewModelType {
    var image: UIImage? { get }
    var name: NSAttributedString { get }
    var categoryMacro: NSAttributedString { get }
    var categoryMicro: NSAttributedString { get }
    var price: NSAttributedString { get }
    var isLiked: Bool { get }
    
    func fetchProductDetails() -> AnyPublisher<AsyncState<[ProductDetailItem]?>, Never>
    func toggleLike()
}

struct ProductDetailViewModel: ProductDetailViewModelType {
    let code8: String
    let image: UIImage?
    var name: NSAttributedString {
        "Name".attributed()
    }
    
    var categoryMacro: NSAttributedString {
        "Macro".attributed()
    }
    
    var categoryMicro: NSAttributedString {
        "Micro".attributed()
    }
    
    var price: NSAttributedString {
        "Price".attributed()
    }
    
    // TODO: Any other useful info?
    
    let productDetailRepository: ProductDetailRepository
    let likesRepository: LikesRepository
    weak var delegate: ProductDetailViewDelegate?

    var isLiked: Bool {
        likesRepository.isLiked(code8)
    }

    func fetchProductDetails() -> AnyPublisher<AsyncState<[ProductDetailItem]?>, Never> {
        productDetailRepository.fetchProductDetail(code8: code8)
    }
    
    func toggleLike() {
        likesRepository.toggleLike(code8)
        delegate?.productDetailViewDidToggleLike(code8)
    }
}
