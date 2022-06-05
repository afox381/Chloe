import SwiftUI

struct ProductView: View {
    @ObservedObject var productService: ProductService
    
    var body: some View {
        switch productService.loadingState {
        case .loading:
            loadingView
        case .success(let productDetailItem):
            ContentView(productDetailItem: productDetailItem, image: productService.image)
        case .failure:
            failureView
        case .inactive:
            Color.clear
        }
    }
    
    var loadingView: some View {
        Text("Loading...") // TODO: Localisation
            .font(Font(UIFont.loading))
            .transition(.opacity)
    }
    
    var failureView: some View {
        VStack(spacing: 8) {
            Spacer()
            Text("Loading Failed") // TODO: Localisation
                .font(Font(UIFont.loadFailureTitle))
            Text("Could not fetch the product details. Please check your internet and try again.") // TODO: Localisation
                .multilineTextAlignment(.center)
                .font(Font(UIFont.loadFailureRetry))
            Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
        .transition(.opacity)
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        let productService = ProductService(code8: "15203484",
                                            image: UIImage(named: "category_sneakers")!,
                                            productDetailRepository: ProductDetailRepository())
        ProductView(productService: productService)
    }
}
