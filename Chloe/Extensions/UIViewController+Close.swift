import UIKit

extension UIViewController {
    private static var onCloseCompletion: (() -> Void)?
    
    func addClose(completion: (() -> Void)?) {
        UIViewController.onCloseCompletion = completion
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(onClose))
        navigationItem.setRightBarButton(closeButton, animated: false)
    }
    
    @objc private func onClose() {
        UIViewController.onCloseCompletion?()
        UIViewController.onCloseCompletion = nil
    }
}
