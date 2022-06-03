import UIKit

protocol CategoryViewModelType {
    var carouselItems: [CarouselItem] { get }
}

struct CategoryViewModel: CategoryViewModelType {
    let carouselItems: [CarouselItem] = [
        CarouselItem(id: "drsss",
                     imageName: "category_dresses",
                     title: "Dresses",
                     backgroundColour: UIColor(named: "ChloeBeige")!),
        CarouselItem(id: "skrtsnds",
                     imageName: "category_shorts",
                     title: "Skirts and Shorts",
                     backgroundColour: UIColor(named: "ChloeBeige")!),
        CarouselItem(id: "nwrrvlsbgs",
                     imageName: "category_bags",
                     title: "Bags",
                     backgroundColour: UIColor(named: "ChloeBeige")!),
        CarouselItem(id: "shssnkrs",
                     imageName: "category_sneakers",
                     title: "Sneakers",
                     backgroundColour: UIColor(named: "ChloeBeige")!),
    ]
}
