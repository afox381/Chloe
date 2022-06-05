import SwiftUI

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
                                  message: Text("We're not quite there yet on likes, but please check back later!"), // TODO: Localisation
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
