import Foundation

protocol CarouselTileViewModelType {
    var imageName: String { get }
    var pct: Double { get }
}

struct CarouselTileViewModel: CarouselTileViewModelType {
    let imageName: String
    let pct: Double
}
