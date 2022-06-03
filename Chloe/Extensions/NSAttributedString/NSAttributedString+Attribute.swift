import UIKit

typealias StringAttributes = [NSAttributedString.Attribute]

extension NSAttributedString {
    struct Attribute {
        let key: NSAttributedString.Key
        let value: Any

        fileprivate init(key: NSAttributedString.Key, value: Any) {
            self.key = key
            self.value = value
        }
    }
}

extension Collection where Element == NSAttributedString.Attribute {
    var dictionary: [NSAttributedString.Key: Any] {
        reduce(into: [:]) { $0[$1.key] = $1.value }
    }
}

extension NSAttributedString.Attribute {

    static func font(_ font: UIFont) -> NSAttributedString.Attribute {
        .init(key: .font, value: font)
    }

    static func foreground(_ color: UIColor) -> NSAttributedString.Attribute {
        .init(key: .foregroundColor, value: color)
    }
}
