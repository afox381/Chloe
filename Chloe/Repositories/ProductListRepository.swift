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
                         itemsPerPage: ProductListRepository.Defaults.itemsPerPage,
                         gender: ProductListRepository.Defaults.gender,
                         page: page)
    }
}

final class ProductListRepository: RemoteRepository, ProductListRepositoryType {
    enum Defaults {
        static let itemsPerPage: Int = 16
        static let gender: String = "D"
    }

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
