import Foundation
import Combine

protocol ProductListRepositoryType {
    func fetchProductList(category: String,
                          itemsPerPage: Int,
                          gender: String,
                          page: Int) -> AnyPublisher<AsyncState<ProductList?>, Never>
}

extension ProductListRepositoryType {
    func fetchProductList(category: String, page: Int) -> AnyPublisher<AsyncState<ProductList?>, Never>  {
        fetchProductList(category: category,
                              itemsPerPage: 16,
                              gender: "D",
                              page: page)
    }
}

final class ProductListRepository: RemoteRepository, ProductListRepositoryType {
    override init(urlSession: URLSession = URLSession.shared) {
        super.init(urlSession: urlSession)
    }

    func fetchProductList(category: String,
                          itemsPerPage: Int,
                          gender: String,
                          page: Int) -> AnyPublisher<AsyncState<ProductList?>, Never>  {
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
