import UIKit

final class MainCoordinator: UINavigationController {
    private let productListRepository = ProductListRepository()
    private let productDetailRepository = ProductDetailRepository()
    private let likesRepository = LikesRepository()
    
    enum Constants {
        static let fakeLaunchScreenDuration: TimeInterval = 2
    }
    
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
    
    private func presentFakeLaunchScreen(on view: UIView, displaySeconds: TimeInterval, completion: @escaping () -> Void) {
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
    
    private func presentCategory(title: String, category: String) {
        let viewModel = ProductListViewModel(title: title,
                                             category: category,
                                             productListRepository: productListRepository,
                                             likesRepository: likesRepository)
        let controller = ProductListViewController(viewModel: viewModel)
        controller.delegate = self

        controller.modalPresentationStyle = .overFullScreen
        categoryController.present(controller, animated: false)
    }
}

extension MainCoordinator: CategoryViewControllerDelegate {
    func didTapCategory(title: String, category: String) {
        presentCategory(title: title, category: category)
    }
}

extension MainCoordinator: ProductListViewControllerDelegate {
    func productListViewControllerDidClose(productListViewController: ProductListViewController) {
        UIView.animate(withDuration: 0.3, animations: {
            productListViewController.view.alpha = 0
        }, completion: { _ in
            productListViewController.dismiss(animated: false)
            productListViewController.view.alpha = 1
            self.categoryController.transitionFromFill()
        })
    }
    
    func productListViewController(_ productListViewController: ProductListViewController,
                                     didSelect productListItem: ProductListItem) {
        let viewModel = ProductDetailViewModel(code8: productListItem.code8,
                                               image: nil,
                                               productDetailRepository: productDetailRepository,
                                               likesRepository: likesRepository)
        let controller = ProductDetailViewController(viewModel: viewModel)
        pushViewController(controller, animated: true)
    }
}

extension MainCoordinator: ProductDetailViewDelegate {
    func productDetailViewDidToggleLike(_ id: String) {
//        productListController.refreshContent() // TODO: Toggle Like
    }
}

