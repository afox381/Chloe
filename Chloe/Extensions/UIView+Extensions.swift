import UIKit

extension UIView {
    func add(child childView: UIView, insets: UIEdgeInsets = .zero, at index: Int? = nil) {
        if let index = index {
            insertSubview(childView, at: index)
        } else {
            addSubview(childView)
        }
        childView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            childView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            childView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            childView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
            ])
    }

    @discardableResult
    func applySurroundingShadow() -> UIView {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 8
        return self
    }
    
    func rotateForever(duration: CFTimeInterval = 3.0) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = Float.greatestFiniteMagnitude
        layer.add(rotateAnimation, forKey: nil)
    }
}
