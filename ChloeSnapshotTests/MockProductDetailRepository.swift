import XCTest
import Combine
@testable import Chloe

public enum HTTPServiceError: Error {
    case dataIsNotDecodable
    case noResponse
}

final class MockProductDetailRepository: ProductDetailRepositoryType {
    var isLoading: Bool = false
    var didFail: Bool = false
    
    func fetchProductDetail(code8: String) -> AnyPublisher<AsyncState<ProductDetailItem>, Never> {
        if isLoading {
            return CurrentValueSubject<AsyncState<ProductDetailItem>, Never>(.loading).eraseToAnyPublisher()
        } else if didFail {
            return CurrentValueSubject<AsyncState<ProductDetailItem>, Never>(.failure(HTTPServiceError.dataIsNotDecodable)).eraseToAnyPublisher()
        } else {
            return CurrentValueSubject<AsyncState<ProductDetailItem>, Never>(.success(ProductDetailItem.arrange())).eraseToAnyPublisher()
        }
    }
}
