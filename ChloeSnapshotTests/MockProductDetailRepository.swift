import XCTest
import Combine
@testable import Chloe

public enum HTTPServiceError: Error {
    case dataIsNotDecodable
    case noResponse
}

final class MockProductDetailRepository: ProductDetailRepositoryType {
    var isSuccessfulResponse: Bool = true
    
    func fetchProductDetail(code8: String) -> AnyPublisher<AsyncState<ProductDetailItem>, Never> {
        if isSuccessfulResponse {
            return CurrentValueSubject<AsyncState<ProductDetailItem>, Never>(.success(ProductDetailItem.arrange())).eraseToAnyPublisher()
        } else {
            return CurrentValueSubject<AsyncState<ProductDetailItem>, Never>(.failure(HTTPServiceError.dataIsNotDecodable)).eraseToAnyPublisher()
        }
    }
}
