import Foundation
import SwiftUI
import Combine

class ProductService: ObservableObject {
    @Published var loadingState: AsyncState<ProductDetailItem> = .inactive
    
    var image: UIImage
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(code8: String,
         image: UIImage,
         productDetailRepository: ProductDetailRepositoryType) {
        
        self.image = image
        
        productDetailRepository.fetchProductDetail(code8: code8)
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                self.loadingState = state
            }
            .store(in: &cancellables)
    }
}
