import UIKit

struct CarouselItem {
    let id: String
    let imageName: String
    let title: String
    let backgroundColour: UIColor
}

protocol CarouselViewModelType {
    var carouselItems: [CarouselItem] { get }
    func attributedTitle(index: Int) -> NSAttributedString
}

struct CarouselViewModel: CarouselViewModelType {
    let carouselItems: [CarouselItem]
    
    func attributedTitle(index: Int) -> NSAttributedString {
        carouselItems[index].title.attributed()
            .applyFont(.categoryTitle)
            .applyForegroundColor(.black)
    }
}
