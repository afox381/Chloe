import UIKit
import Combine

protocol ProductListViewControllerDelegate: AnyObject {
    func productListViewController(_ productListViewController: ProductListViewController,
                                   didSelect productListItem: ProductListItem,
                                   image: UIImage?)
}

final class ProductListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadFailedStackView: UIStackView!
    @IBOutlet weak var loadFailedLabel: UILabel!
    @IBOutlet weak var loadFailedRetryButton: UIButton!
    
    enum Constants {
        static let productItemCellID: String = "productItemCellID"
        static let itemsFromEndToStartPaging: Int = 10
        static let headerHeight: CGFloat = 43
        static let cellSpacing: CGFloat = 8
        static let cellWidthHeighRatio: CGFloat = 1.67
        static let imageResolution: String = "21" // 480x640
    }
    
    private let viewModel: ProductListViewModelType
    private var cancellables: Set<AnyCancellable> = []
    private var productListItems: [ProductListItem] = []
    private var currentProductListPage: Int = 0
    private var totalResults: Int = 0
    private var isFetching: Bool = false
    
    weak var delegate: ProductListViewControllerDelegate?
    
    init(viewModel: ProductListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupDynamicUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        fetchProductList(page: currentProductListPage, withLoadingHUD: true)
    }
    
    private func setupDynamicUI() {
        title = viewModel.title
    }
    
    private func setupCollectionView() {
        let cellNib = UINib(nibName: String(describing: ProductListCollectionViewCell.self), bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: Constants.productItemCellID)
        collectionView.alpha = 0
    }
    
    private func fetchProductList(page: Int, withLoadingHUD: Bool) {
        guard !isFetching else { return }
        isFetching = true

        viewModel.fetchProductList(page: page)
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .loading:
                    if page == 0 {
                        self.view.showLoadingHUD(type: .loading, withFader: false)
                    }
                case .success(let productList):
                    self.isFetching = false
                    self.view.hideLoadingHUD() {
                        guard let productList = productList else {
                            self.presentFetchError(.unexpectedResponse)
                            return
                        }
                        self.totalResults = productList.resultsLite.totalResults
                        self.productListItems.append(contentsOf: productList.resultsLite.items)
                        self.collectionView.reloadData()
                        if self.collectionView.alpha == 0 {
                            UIView.animate(withDuration: 0.3) {
                                self.collectionView.alpha = 1
                            }
                        }
                    }
                case .failure:
                    self.isFetching = false
                    if page == 0, self.productListItems.count == 0 {
                        self.view.hideLoadingHUD() {
                            self.setLoadFailureHidden(false)
                        }
                    }
                case .inactive:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func setLoadFailureHidden(_ isHidden: Bool, completion: (() -> Void)? = nil) {
        loadFailedLabel.attributedText = viewModel.loadFailureTitle
        loadFailedRetryButton.setAttributedTitle(viewModel.loadFailureRetry, for: .normal)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.loadFailedStackView.alpha = isHidden ? 0 : 1
        }, completion: { _ in
            completion?()
        })
    }
    
    private func presentFetchError(_ error: RepositoryError?) {
        let alert = UIAlertController(title: "Fetch Failed", message: "Products failed to download. Please check your internet connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
            self.fetchProductList(page: self.currentProductListPage, withLoadingHUD: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func didTapRetry() {
        setLoadFailureHidden(true) {
            self.fetchProductList(page: self.currentProductListPage, withLoadingHUD: true)
        }
    }
}

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productListItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.productItemCellID, for: indexPath) as! ProductListCollectionViewCell
        let productListItem = productListItems[indexPath.item]
        cell.update(with: ProductListCollectionViewCellViewModel(productListItem: productListItem,
                                                                 imageResolution: Constants.imageResolution,
                                                                 isLiked: viewModel.isLiked(productId: productListItem.code8)))
        return cell
    }
}

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductListCollectionViewCell else { return }
        let productListItem = productListItems[indexPath.row]
        delegate?.productListViewController(self, didSelect: productListItem, image: cell.imageView.image)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item > productListItems.count - Constants.itemsFromEndToStartPaging,
            productListItems.count < totalResults,
           !isFetching {
            currentProductListPage += 1
            fetchProductList(page: currentProductListPage, withLoadingHUD: false)
        }
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: Constants.headerHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let screenWidth = UIScreen.main.bounds.width - (sectionInset.left + sectionInset.right + Constants.cellSpacing)
        let width = floor(screenWidth / 2)
        let height = width * Constants.cellWidthHeighRatio
        return CGSize(width: width, height: height)
    }
}
