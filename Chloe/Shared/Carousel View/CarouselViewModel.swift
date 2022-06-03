import UIKit

struct CarouselItem {
    let id: String
    let imageName: String
    let attributedTitle: NSAttributedString
    let backgroundColour: UIColor
}

protocol CarouselViewModelType {
    var carouselItems: [CarouselItem] { get }
}

struct CarouselViewModel: CarouselViewModelType {
    let carouselItems: [CarouselItem]
}
