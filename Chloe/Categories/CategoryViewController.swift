import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func didTapCategory(title: String, category: String)
}

final class CategoryViewController: UIViewController {
    @IBOutlet weak var titleContainerView: UIView!
    
    private lazy var carouselView: CarouselView = {
        let carouselView = CarouselView.loadFromNib()
        carouselView.delegate = self
        carouselView.viewModel = CarouselViewModel(carouselItems: viewModel.carouselItems,
                                                   viewWidth: UIScreen.main.bounds.width)
        return carouselView
    }()
    
    let viewModel: CategoryViewModelType
    weak var delegate: CategoryViewControllerDelegate?
    
    init(viewModel: CategoryViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ChloeGrey")
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.add(child: carouselView)
    }
    
    func transitionFromFill() {
        carouselView.transitionTileFromFill()
    }
}

extension CategoryViewController: CarouselViewDelegate {
    func carouselViewDidBeginUpdating(_ carouselView: CarouselView) {
        // Do nothing
    }
    
    func carouselViewDidEndUpdating(_ carouselView: CarouselView) {
        // Do nothing
    }
    
    func carouselViewDidTap(_ carouselView: CarouselView, currentTile: Int) {
        carouselView.transitionTileToFill {
            self.delegate?.didTapCategory(title: self.viewModel.carouselItems[currentTile].title,
                                          category: self.viewModel.carouselItems[currentTile].id)
        }
    }
}
