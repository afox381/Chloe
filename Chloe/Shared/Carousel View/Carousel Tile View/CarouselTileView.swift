import UIKit

final class CarouselTileView: UIView {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var highlightContainerView: UIView!
    @IBOutlet weak var highlightCentreXConstraint: NSLayoutConstraint!
    @IBOutlet weak var highlightCentreYConstraint: NSLayoutConstraint!
    
    enum Metrics {
        static let parallaxAmplitude: CGFloat = 900
        
        enum Motion {
            static let maxHighlight: CGFloat = 800
            static let maxShadow: CGFloat = 15
        }
    }

    var pct: CGFloat = 0
    var viewModel: CarouselTileViewModelType! {
        didSet {
            setupViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setupViews() {
        pct = viewModel.pct
        backgroundImageView.image = UIImage(named: viewModel.imageName)
    }
}
