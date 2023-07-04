import UIKit

struct CarouselItem {
    let id: String
    let imageName: String
    let title: String
    let backgroundColour: UIColor
}

protocol CarouselViewModelType {
    var tileViewModels: [CarouselTileViewModel] { get }
    func backgroundColour(for index: Int) -> UIColor
    func attributedTitle(index: Int) -> NSAttributedString
    func pageIndex(for offsetX: Double) -> Int
}

class CarouselViewModel: CarouselViewModelType {
    enum Constants {
        static let alphaStartPct: CGFloat = 0.3
        static let alphaEndPct: CGFloat = 0.7
        static let zTranslationDelta: CGFloat = 250
        static let tilePctDelta: CGFloat = 0.5
    }

    var tileViewModels: [CarouselTileViewModel] = []
    private let viewWidth: Double

    private var carouselItems: [CarouselItem] {
        didSet {
            setupTileViewModels()
        }
    }

    init(carouselItems: [CarouselItem], viewWidth: Double) {
        self.carouselItems = carouselItems
        self.viewWidth = viewWidth
        setupTileViewModels()
    }
    
    func backgroundColour(for index: Int) -> UIColor {
        carouselItems[index].backgroundColour
    }

    func attributedTitle(index: Int) -> NSAttributedString {
        carouselItems[index].title.attributed()
            .applyFont(.categoryTitle)
            .applyForegroundColor(.black)
    }

    func pageIndex(for offsetX: Double) -> Int {
        Int((offsetX + (viewWidth / 2)) / viewWidth) % carouselItems.count
    }

    private func setupTileViewModels() {
        tileViewModels = carouselItems.enumerated().map { index, item in
            let attributes = TileViewAttributes(pct: CGFloat(index + 1) * Constants.tilePctDelta,
                                                transform: .Identity.Perspective.low,
                                                alpha: 0.0)
            return CarouselTileViewModel(imageName: item.imageName, viewAttributes: attributes)
        }
    }

    func updateTileViews(delta: CGFloat) {
        tileViewModels.forEach {
            updateSingleTileView($0, with: delta)
        }
    }

    private func updateSingleTileView(_ tileViewModel: CarouselTileViewModel, with delta: CGFloat) {
        let newPct = pct(for: tileViewModel.pct, with: delta)
        let boundedPct = min(max(newPct, 0), 1)
        let shiftedPct = (boundedPct * 2) - 1
        let curvedPct = sin((shiftedPct * 30).inRadians)

        let xTranslation = curvedPct * (390 * 2) // (UIScreen.main.bounds.width * 2)
        let zTranslation: CGFloat = abs(curvedPct) * 100
        var transform = CATransform3D.Identity.Perspective.low
        transform = CATransform3DTranslate(transform, xTranslation, 0, zTranslation)
        transform = CATransform3DRotate(transform, (curvedPct * -25).inRadians, 0, 1, 0)

        tileViewModel.update(attributes: TileViewAttributes(pct: newPct,
                                                            transform: transform,
                                                            alpha: alpha(for: boundedPct)))
    }

    private func pct(for pct: CGFloat, with delta: CGFloat) -> CGFloat {
        var newPct = pct + delta / (viewWidth * 2)
        if newPct > 1.0, delta > 0 {
            newPct -= CGFloat(carouselItems.count) * Constants.tilePctDelta
        } else if newPct < 0, delta < 0 {
            newPct += CGFloat(carouselItems.count) * Constants.tilePctDelta
        }
        return newPct
    }

    private func alpha(for pct: CGFloat) -> CGFloat {
        let alpha: CGFloat
        switch pct {
        case 0...Constants.alphaStartPct:
            alpha = min(abs(1 - ((Constants.alphaStartPct - pct) / Constants.alphaStartPct)), 1)
        case Constants.alphaEndPct..<1.0:
            alpha = min(abs(1 - ((pct - Constants.alphaEndPct) / (1 - Constants.alphaEndPct))), 1)
        case 1.0...999, -999..<0.0:
            alpha = 0
        default:
            alpha = 1
        }
        return alpha
    }

}
