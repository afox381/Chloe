import UIKit

extension UIStackView {
    func replaceSubviews(with views: [UIView]) {
        removeAllArrangedSubviews()
        addArrangedSubviews(views)
    }

    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            addArrangedSubview($0)
        }
    }

    @discardableResult
    func removeArrangedSubViewProperly(_ view: UIView) -> UIView {
        removeArrangedSubview(view)
        NSLayoutConstraint.deactivate(view.constraints)
        view.removeFromSuperview()
        return view
    }

    @discardableResult
    func removeAllArrangedSubviews(fromIndex index: Int = 0) -> [UIView] {
        guard self.arrangedSubviews.count > index else { return [] }
        return arrangedSubviews[index...].reduce([UIView]()) { $0 + [removeArrangedSubViewProperly($1)] }
    }
}
