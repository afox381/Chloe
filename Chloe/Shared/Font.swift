import UIKit

enum Font {
    static let categoryTitle: UIFont = Futura2.regular(ofSize: 21)
    static let loadFailureTitle: UIFont = Futura2.regular(ofSize: 32)
    static let loadFailureRetry: UIFont = Futura2.regular(ofSize: 20)

    static private let sizeDeviceModifier: CGFloat = UIDevice.isIPad ? 1.2 : 1

    enum Futura2 {
        static func regular(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "FuturaNo2DEE", size: size * sizeDeviceModifier)!
        }
    }
}
