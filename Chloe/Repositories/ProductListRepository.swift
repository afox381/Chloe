import Foundation
import Combine

final class ProductListRepository: RemoteRepository {
    override init(urlSession: URLSession = URLSession.shared) {
        super.init(urlSession: urlSession)
    }

    func fetchProductList(category: String) -> AnyPublisher<AsyncState<[ProductListItem]?>, Never>  {
        // Todo: Category list fetch
        dataTask(httpMethod: .get,
                 urlString: "\(Url.base)/\(Url.characters)")
    }
}
