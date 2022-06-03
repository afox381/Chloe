import UIKit

enum Font {
    static var categoryTitle: UIFont {
        switch UIDevice.current.modelType {
        case .iPhone5:
            return Futura2.regular(ofSize: 10)
        case .iPhone678, .iPhoneX:
            return Futura2.regular(ofSize: 21)
        default:
            return Futura2.regular(ofSize: 32)
        }
    }

    static private let sizeDeviceModifier: CGFloat = UIDevice.isIPad ? 1.2 : 1

    enum Futura2 {
        static func regular(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "FuturaNo2DEE", size: size * sizeDeviceModifier)!
        }
    }
}
