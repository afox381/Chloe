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

struct ContentView: View {
    @State private var showingAlert = false
    
    var productDetailItem: ProductDetailItem
    var image: UIImage
    
    enum Constants {
        static let productDetailsHeader: String = "PRODUCT DETAILS" // TODO: Localisation
        static let descriptionHeader: String = "DESCRIPTION" // TODO: Localisation
    }

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 8) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                Group {
                    HStack {
                        Text(productDetailItem.name)
                            .font(Font(UIFont.Detail.name))
                        Spacer()
                        Button(action: {
                            showingAlert = true
                        }) {
                            Image(systemName: "heart")
                                .foregroundColor(.black)
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Sorry!"), // TODO: Localisation
                                  message: Text("We're not quite there yet on likes, but check back later!"), // TODO: Localisation
                                  dismissButton: .default(Text("Okay")))
                        }
                    }
                    Text(productDetailItem.price)
                        .font(Font(UIFont.Detail.price))
                }
                Spacer()
                Divider()
                Group {
                    Text(Constants.productDetailsHeader)
                        .font(Font(UIFont.Detail.productDetailsHeader))
                    Text(productDetailItem.macroCategory)
                        .font(Font(UIFont.Detail.details))
                    Text(productDetailItem.microCategory)
                        .font(Font(UIFont.Detail.details))
                }
                Spacer()
                Divider()
                Group {
                    Text(Constants.descriptionHeader)
                        .font(Font(UIFont.Detail.descriptionHeader))
                    Text(productDetailItem.description)
                        .font(Font(UIFont.Detail.details))
                    Spacer()
                    Text(productDetailItem.madeIn)
                        .font(Font(UIFont.Detail.details))
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
        }
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
