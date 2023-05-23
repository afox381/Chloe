import Combine
import UIKit

final class CarouselTileView: UIView {
    @IBOutlet weak var backgroundImageView: UIImageView!

    private var subscriptions: Set<AnyCancellable> = .init()

    var viewModel: CarouselTileViewModelType! {
        didSet {
            bind()
            setupViews()
        }
    }

    private func bind() {
        subscriptions = []

        viewModel.attributesPublisher.sink { [weak self] attributes in
            self?.updateViewAttributes(attributes)
        }
        .store(in: &subscriptions)
    }

    private func setupViews() {
        backgroundImageView.image = UIImage(named: viewModel.imageName)
    }

    private func updateViewAttributes(_ viewAttributes: TileViewAttributes) {
        layer.sublayerTransform = viewAttributes.transform
        alpha = viewAttributes.alpha
    }
}
