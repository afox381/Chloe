import Foundation
import Combine

protocol ProductDetailRepositoryType {
    func fetchProductDetail(productId: String) -> AnyPublisher<AsyncState<[ProductDetailItem]?>, Never>
}

final class ProductDetailRepository: RemoteRepository, ProductDetailRepositoryType {
    override init(urlSession: URLSession = URLSession.shared) {
        super.init(urlSession: urlSession)
    }

    func fetchProductDetail(productId: String) -> AnyPublisher<AsyncState<[ProductDetailItem]?>, Never> {
        dataTask(httpMethod: .get,
                 urlString: "\(Url.base)/\(Url.quote)",
                 queryParams: [
                    "author": "something? Nothing?"//name.replacingOccurrences(of: " ", with: "+")
                 ])
    }
}
