import UIKit

extension UIFont {
    static let navigationTitle: UIFont = Futura2.regular(ofSize: 21)
    static let categoryTitle: UIFont = Futura2.regular(ofSize: 21)
    static let loading: UIFont = Futura2.regular(ofSize: 21)
    static let loadFailureTitle: UIFont = Futura2.regular(ofSize: 24)
    static let loadFailureRetry: UIFont = Futura2.regular(ofSize: 18)
    static let listPrice: UIFont = Futura2.bold(ofSize: 14)
    static let listTitle: UIFont = Futura2.regular(ofSize: 14)
    
    enum Detail {
        static let name: UIFont = Futura2.regular(ofSize: 18)
        static let price: UIFont = Futura2.bold(ofSize: 20)
        static let productDetailsHeader: UIFont = Futura2.regular(ofSize: 16)
        static let descriptionHeader: UIFont = Futura2.regular(ofSize: 16)
        static let details: UIFont = Futura2.regular(ofSize: 14)
    }

    static private let sizeDeviceModifier: CGFloat = UIDevice.isIPad ? 1.2 : 1

    enum Futura2 {
        static func regular(ofSize size: CGFloat) -> UIFont {
            UIFont(name: "FuturaNo2DEE", size: size * sizeDeviceModifier)!
        }
        
        static func bold(ofSize size: CGFloat) -> UIFont {
            UIFont(name: "FuturaNo2DW03-Bold", size: size * sizeDeviceModifier)!
        }
    }
}
