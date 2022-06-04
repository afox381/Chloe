//
//  ProductView.swift
//  Chloe
//
//  Created by Andrew Fox on 04/06/2022.
//

import SwiftUI

struct ProductView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    var body: some View {
        //                guard let self = self else { return }
        //
        //                switch state {
        //                case .loading:
        //                    if page == 0 {
        //                        self.view.showLoadingHUD(type: .loading, withFader: false)
        //                    }
        //                case .success(let productList):
        //                    self.isFetching = false
        //                    self.view.hideLoadingHUD() {
        //                        guard let productList = productList else {
        //                            self.presentFetchError(.unexpectedResponse)
        //                            return
        //                        }
        //                        self.totalResults = productList.resultsLite.totalResults
        //                        self.productListItems.append(contentsOf: productList.resultsLite.items)
        //                        self.collectionView.reloadData()
        //                        if self.collectionView.alpha == 0 {
        //                            UIView.animate(withDuration: 0.3) {
        //                                self.collectionView.alpha = 1
        //                            }
        //                        }
        //                    }
        //                case .failure:
        //                    self.isFetching = false
        //                    if page == 0, self.productListItems.count == 0 {
        //                        self.view.hideLoadingHUD() {
        //                            self.setLoadFailureHidden(false)
        //                        }
        //                    }
        //                case .inactive:
        //                    break
        //                }

        switch viewModel.loadingState {
        case .loading:
            loadingView
        case .success(let productDetailItem):
            ContentView(productDetailItem: productDetailItem, image: viewModel.image)
        case .failure:
            failureView
        case .inactive:
            Color.clear
        }
    }
    
    var loadingView: some View {
        Text("Loading...")
    }
    
    var failureView: some View {
        Text("Failure. :(")
    }
}

struct ContentView: View {
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
                    Text(productDetailItem.name)
                        .font(Font(UIFont.Detail.name))
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
            }.padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ProductViewModel(code8: "15203484",
                                         image: UIImage(named: "category_sneakers")!,
                                         productDetailRepository: ProductDetailRepository())
        ProductView(viewModel: viewModel)
    }
}
