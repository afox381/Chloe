import UIKit

class ClosureSleeve {
    let closure: () -> Void
    
    init (_ closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIViewController {
    func addClose(completion: @escaping () -> Void) {
        let sleeve = ClosureSleeve(completion)
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                          style: .plain,
                                          target: sleeve,
                                          action: #selector(ClosureSleeve.invoke))
        navigationItem.setRightBarButton(closeButton, animated: false)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
