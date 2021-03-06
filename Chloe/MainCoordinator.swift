import UIKit
import SwiftUI

final class MainCoordinator: UINavigationController {
    private let productListRepository = ProductListRepository()
    private let productDetailRepository = ProductDetailRepository()
    private let likesRepository = LikesRepository()
    private var productListNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.navigationBar.tintColor = .black
        navigationController.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.navigationTitle
        ]
        return navigationController
    }()
    private lazy var categoryController: CategoryViewController = {
        let controller = CategoryViewController(viewModel: CategoryViewModel())
        controller.delegate = self
        return controller
    }()

    private let emptyImage = UIImage(named: "empty_picture")!

    enum Constants {
        static let fakeLaunchScreenDuration: TimeInterval = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentCategories()
        presentFakeLaunchScreen(on: categoryController.view, displaySeconds: Constants.fakeLaunchScreenDuration)
    }
    
    private func presentCategories() {
        viewControllers = [categoryController]
    }
    
    private func presentFakeLaunchScreen(on view: UIView, displaySeconds: TimeInterval, completion: (() -> Void)? = nil) {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let launchViewController = storyboard.instantiateViewController(withIdentifier: "viewController")
        view.add(child: launchViewController.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + displaySeconds) {
            UIView.animate(withDuration: 0.3, animations: {
                launchViewController.view.alpha = 0
                launchViewController.view.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
            }, completion: { _ in
                launchViewController.view.removeFromSuperview()
                completion?()
            })
        }
    }
    
    private func presentCategory(title: String, category: String) {
        let viewModel = ProductListViewModel(title: title,
                                             category: category,
                                             productListRepository: productListRepository,
                                             likesRepository: likesRepository)
        let controller = ProductListViewController(viewModel: viewModel)
        controller.delegate = self
        
        productListNavigationController.viewControllers = [controller]
        categoryController.present(productListNavigationController, animated: false)
        
        controller.addClose {
            self.productListViewControllerDidClose(productListViewController: controller)
        }
    }
    
    func productListViewControllerDidClose(productListViewController: ProductListViewController) {
        UIView.animate(withDuration: 0.3, animations: {
            self.productListNavigationController.view.alpha = 0
        }, completion: { _ in
            self.categoryController.transitionFromFill()
            self.productListNavigationController.dismiss(animated: false)
            self.productListNavigationController.viewControllers = []
            self.productListNavigationController.view.alpha = 1
        })
    }
}

extension MainCoordinator: CategoryViewControllerDelegate {
    func didTapCategory(title: String, category: String) {
        presentCategory(title: title, category: category)
    }
}

extension MainCoordinator: ProductListViewControllerDelegate {
    func productListViewController(_ productListViewController: ProductListViewController,
                                   didSelect productListItem: ProductListItem,
                                   image: UIImage?) {
        let productService = ProductService(code8: productListItem.code8,
                                            image: image ?? emptyImage,
                                            productDetailRepository: productDetailRepository)
        
        let hostingController = UIHostingController(rootView: ProductView(productService: productService))
        productListNavigationController.pushViewController(hostingController, animated: true)
    }
}
