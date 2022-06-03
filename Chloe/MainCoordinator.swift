import UIKit

final class MainCoordinator: UINavigationController {
    private let productListRepository = ProductListRepository()
    private let productDetailRepository = ProductDetailRepository()
    private let likesRepository = LikesRepository()
    
    enum Constants {
        static let fakeLaunchScreenDuration: TimeInterval = 2
    }
    
    lazy var productListController: ProductListViewController = {
        let viewModel = ProductListViewModel(title: "Title",
                                             category: "Category",
                                             productListRepository: productListRepository,
                                             likesRepository: likesRepository)
        let controller = ProductListViewController(viewModel: viewModel)
        controller.delegate = self
        return controller
    }()
    
    lazy var categoryController: CategoryViewController = {
        let controller = CategoryViewController(viewModel: CategoryViewModel())
        controller.delegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentCategories()
        presentFakeLaunchScreen(on: categoryController.view, displaySeconds: Constants.fakeLaunchScreenDuration) {
            self.categoryController.start()
        }
    }
    
    private func presentCategories() {
        viewControllers = [categoryController]
    }
    
    func presentFakeLaunchScreen(on view: UIView, displaySeconds: TimeInterval, completion: @escaping () -> Void) {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let launchViewController = storyboard.instantiateViewController(withIdentifier: "viewController")
        view.add(child: launchViewController.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + displaySeconds) {
            UIView.animate(withDuration: 0.3, animations: {
                launchViewController.view.alpha = 0
                launchViewController.view.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
            }, completion: { _ in
                launchViewController.view.removeFromSuperview()
                completion()
            })
        }
    }
}

extension MainCoordinator: CategoryViewControllerDelegate {
    func didTapCategory(id: String) {
        productListController.modalPresentationStyle = .overFullScreen
        categoryController.present(productListController, animated: false)
    }
}

extension MainCoordinator: ProductListViewControllerDelegate {
    func productListViewControllerDidClose() {
        UIView.animate(withDuration: 0.3, animations: {
            self.productListController.view.alpha = 0
        }, completion: { _ in
            self.productListController.dismiss(animated: false)
            self.productListController.view.alpha = 1
            self.categoryController.transitionFromFill()
        })
    }
    
    func productListViewController(_ productListViewController: ProductListViewController,
                                     didSelect productListItem: ProductListItem) {
        let viewModel = ProductDetailViewModel(id: productListItem.id,
                                               name: productListItem.name,
                                               occupation: productListItem.occupation,
                                               status: productListItem.status,
                                               image: nil, // TODO: image!
                                               productDetailRepository: productDetailRepository,
                                               likesRepository: likesRepository,
                                               delegate: self)
        let controller = ProductDetailViewController(viewModel: viewModel)
        pushViewController(controller, animated: true)
    }
}

extension MainCoordinator: ProductDetailViewDelegate {
    func productDetailViewDidToggleLike(_ id: String) {
        productListController.refreshContent()
    }
}

