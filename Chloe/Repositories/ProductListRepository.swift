import Foundation
import Combine

final class ProductListRepository: RemoteRepository {
    override init(urlSession: URLSession = URLSession.shared) {
        super.init(urlSession: urlSession)
    }

    func fetchProductList(category: String,
                          itemsPerPage: Int = 16,
                          gender: String = "D",
                          page: Int = 0) -> AnyPublisher<AsyncState<ProductList?>, Never>  {
        dataTask(httpMethod: .get,
                 urlString: "\(Url.base)/\(Url.productList)",
                 queryParams: [
                    "ave": "prod",
                    "productsPerPage": "\(itemsPerPage)",
                    "gender": gender,
                    "page": "\(page)",
                    "department": category,
                    "format": "lite",
                    "sortRule": "Ranking"
                 ]
        )
    }
}
