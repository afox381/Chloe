import UIKit

protocol CategoryViewModelType {
    var carouselItems: [CarouselItem] { get }
}

struct CategoryViewModel: CategoryViewModelType {
    let carouselItems: [CarouselItem] = [
        CarouselItem(id: "dresses",
                    imageName: "category_dresses",
                     attributedTitle: "Dresses".attributed().applyFont(Font.categoryTitle).applyForegroundColor(.black),
                     backgroundColour: UIColor(named: "ChloeBeige")!),
        CarouselItem(id: "shorts",
                     imageName: "category_shorts",
                     attributedTitle: "Skirts and Shorts".attributed().applyFont(Font.categoryTitle).applyForegroundColor(.black),
                     backgroundColour: UIColor(named: "ChloeBeige")!),
        CarouselItem(id: "bags",
                     imageName: "category_bags",
                     attributedTitle: "Bags".attributed().applyFont(Font.categoryTitle).applyForegroundColor(.black),
                     backgroundColour: UIColor(named: "ChloeBeige")!),
        CarouselItem(id: "sneakers",
                     imageName: "category_sneakers",
                     attributedTitle: "Sneakers".attributed().applyFont(Font.categoryTitle).applyForegroundColor(.black),
                     backgroundColour: UIColor(named: "ChloeBeige")!),
    ]
}
