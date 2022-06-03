import UIKit

enum HUDDisplayType {
    case loading
    case authenticating
    
    var description: String {
        switch self {
        case .loading: return "Loading..."
        case .authenticating: return "Authenticating..."
        }
    }
}

protocol HUDType {
    func showLoadingHUD(type: HUDDisplayType, withFader: Bool, _ completion: (() -> Void)?)
    func hideLoadingHUD(_ completion: (() -> Void)?)
}

extension UIView: HUDType {
    enum Metrics {
        static let minimumShowTime: TimeInterval = 2.0
    }
    static private var hud = LoadingHUD.loadFromNib()
    static private var showTime: TimeInterval?
    
    /// Shows a loadingHUD on the keyWindow. Enqueues the display if one is already visible.
    func showLoadingHUD(type: HUDDisplayType, withFader: Bool, _ completion: (() -> Void)? = nil) {
        UIView.showTime = Date().timeIntervalSince1970
        DispatchQueue.main.async {
            self.add(child: UIView.hud)
            UIView.hud.titleLabel.text = type.description
            UIView.hud.show(withFader: withFader) {
                completion?()
            }
        }
    }

    /// Hides the currently displayed loadingHUD, showing the next enqueued loadingHUD if available.
    func hideLoadingHUD(_ completion: (() -> Void)? = nil) {
        guard let showTime = UIView.showTime else {
            completion?()
            return
        }
        
        let timeDelta = Date().timeIntervalSince1970 - showTime
        let extraTimeNeeded = max(Metrics.minimumShowTime - timeDelta, 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + extraTimeNeeded) {
            guard let _ = UIView.hud.superview, !UIView.hud.isHiding else {
                completion?()
                return
            }
            UIView.hud.hide {
                UIView.hud.removeFromSuperview()
                completion?()
            }
        }
    }
}

final class LoadingHUD: UIView {
    @IBOutlet weak var containerViewCentreYConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewCentreYWithMultiplierConstraint: NSLayoutConstraint!
    @IBOutlet weak var faderView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var spinnerImageView: UIImageView!
    
    private var defaultBackgroundAlpha: CGFloat = 0.4
    private(set) var isHiding = false
    private var isEnding = false
    
    fileprivate func show(withFader: Bool, _ completion: @escaping () -> Void) {
        initialise(withFader)
        resetAnimations()
        doShowAnimation {
            completion()
        }
    }
    
    private func initialise(_ withFader: Bool) {
        isEnding = false
        isHiding = false
        faderView.isHidden = !withFader
        spinnerImageView.rotateForever(duration: 1.0)
    }
    
    fileprivate func hide(_ completion: @escaping () -> Void) {
        isHiding = true
        doHideAnimation {
            self.removeFromSuperview()
            self.isHiding = false
            completion()
        }
    }
    
    fileprivate func resetAnimations() {
        alpha = 0
    }
    
    fileprivate func doShowAnimation(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
            self.alpha = 1
        }, completion: { _ in
            completion()
        })
    }
    
    fileprivate func doHideAnimation(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.alpha = 0
        }, completion: { _ in
            completion()
        })
    }
}
