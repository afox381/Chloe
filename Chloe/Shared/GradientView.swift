import UIKit

class GradientView: UIView {
    @IBInspectable
    var topColour: UIColor? {
        didSet {
            refreshColours()
        }
    }

    @IBInspectable
    var bottomColour: UIColor? {
        didSet {
            refreshColours()
        }
    }

    override open class var layerClass: AnyClass {
        CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func refreshColours() {
        let gradientLayer = layer as? CAGradientLayer
        gradientLayer?.colors = [(topColour ?? .white).cgColor, (bottomColour ?? .white).cgColor]
    }
}
