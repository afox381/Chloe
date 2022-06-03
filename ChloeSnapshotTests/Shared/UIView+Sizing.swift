import UIKit

extension UIView {

    func setFrameForSizeFitting(width: CGFloat) {
        let targetSize = CGSize(width: width, height: 0)
        let fittingSize = self.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required,
                                                       verticalFittingPriority: .fittingSizeLevel)
        self.frame.size = fittingSize
    }

    func setFrameForSizeFitting(height: CGFloat) {
        let targetSize = CGSize(width: 0, height: height)
        let fittingSize = self.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel,                                                               verticalFittingPriority: .required)
        self.frame.size = fittingSize
    }

}
