import Combine
import Foundation
import UIKit

protocol CarouselTileViewModelType {
    var imageName: String { get }
    var attributesPublisher: AnyPublisher<TileViewAttributes, Never> { get }
}

struct TileViewAttributes {
    let pct: Double
    let transform: CATransform3D
    let alpha: Double
}

class CarouselTileViewModel: CarouselTileViewModelType {
    let imageName: String
    var pct: Double { attributesSubject.value.pct }

    private let attributesSubject: CurrentValueSubject<TileViewAttributes, Never> = .init(TileViewAttributes(pct: 0.0, transform: .Identity.Perspective.low, alpha: 0.0))
    private(set) lazy var attributesPublisher: AnyPublisher<TileViewAttributes, Never> = { attributesSubject.eraseToAnyPublisher() }()

    init(imageName: String, viewAttributes: TileViewAttributes) {
        self.imageName = imageName
        update(attributes: viewAttributes)
    }

    func update(attributes: TileViewAttributes) {
        attributesSubject.send(attributes)
    }
}
