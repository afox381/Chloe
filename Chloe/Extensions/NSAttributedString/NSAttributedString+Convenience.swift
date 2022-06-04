import UIKit

extension NSAttributedString {
    public var range: NSRange { .init(location: 0, length: length) }
    public var mutable: NSMutableAttributedString { .init(attributedString: self) }
}

extension NSAttributedString {
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let string = lhs.mutable
        string.append(rhs)
        return string
    }
}

extension NSMutableAttributedString {
    static func += (lhs: NSMutableAttributedString, rhs: NSAttributedString) {
        lhs.append(rhs)
    }
}

extension NSAttributedString {
    static let newLine: NSAttributedString = "\n".attributed()
    static let space: NSAttributedString = " ".attributed()

    func applyForegroundColor(_ color: UIColor, range: NSRange? = nil) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)

        copy.addAttribute(.foregroundColor,
                          value: color,
                          range: range ?? NSRange(location: 0, length: self.string.count))
        return copy
    }

    func applyFont(_ font: UIFont, range: NSRange? = nil) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        let range = range ?? NSRange(location: 0, length: self.string.count)
        copy.addAttribute(.font,
                          value: font,
                          range: range)
        return copy
    }

    func applyKern(_ value: CGFloat) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        guard !self.string.isEmpty else { return self }
        copy.addAttribute(.kern,
            value: value,
            range: NSRange(location: 0, length: self.string.count - 1))
        return copy
    }

    func applyUnderline(_ underlineStyle: NSUnderlineStyle = .single, range: NSRange? = nil) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        let range = range ?? NSRange(location: 0, length: self.string.count)
        copy.addAttribute(.underlineStyle,
                          value: underlineStyle.rawValue,
                          range: range)
        return copy
    }

    func applyParagraphStyling(alignment: NSTextAlignment? = nil,
                               lineSpacing: CGFloat? = nil,
                               lineBreakMode: NSLineBreakMode? = nil) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        let style = NSMutableParagraphStyle()

        if let alignment = alignment {
            style.alignment = alignment
        }

        if let lineSpacing = lineSpacing {
            style.lineSpacing = lineSpacing
        }

        if let lineBreakMode = lineBreakMode {
            style.lineBreakMode = lineBreakMode
        }

        copy.addAttribute(.paragraphStyle,
                          value: style,
                          range: NSRange(location: 0, length: self.string.count))

        return copy
    }

    func add(_ anotherAttributedString: NSAttributedString) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        copy.append(anotherAttributedString)
        return copy
    }

    func applyStrikethrough(style: NSUnderlineStyle = .single,
                            color: UIColor? = nil,
                            range: NSRange? = nil) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        let range = range ?? NSRange(location: 0, length: self.string.count)
        copy.addAttribute(.strikethroughStyle,
                          value: NSNumber(value: style.rawValue),
                          range: range)
        if let color = color {
            copy.addAttribute(.strikethroughColor,
                              value: color,
                              range: range)
        } else {
            copy.removeAttribute(.strikethroughColor,
                                 range: range)
        }

        return copy
    }

    func height(containerWidth: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil)
        return rect.size.height
    }
}

extension Array where Element == NSAttributedString {
    func joined(separator: NSAttributedString? = nil) -> NSAttributedString {
        var result = NSAttributedString()
        for (index, value) in self.enumerated() {
            if let separator = separator, index > 0 {
                result = result.add(separator)
            }

            result = result.add(value)
        }

        return result
    }
}
