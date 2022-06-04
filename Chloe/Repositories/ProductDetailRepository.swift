import Foundation
import Combine

protocol ProductDetailRepositoryType {
    func fetchProductDetail(code8: String) -> AnyPublisher<AsyncState<ProductDetailItem>, Never>
}

final class ProductDetailRepository: RemoteRepository, ProductDetailRepositoryType {
    override init(urlSession: URLSession = URLSession.shared) {
        super.init(urlSession: urlSession)
    }

    func fetchProductDetail(code8: String) -> AnyPublisher<AsyncState<ProductDetailItem>, Never> {
        dataTask(httpMethod: .get,
                 urlString: "\(Url.base)/\(Url.productDetail(code8: code8))")
    }
}
