import UIKit
import Combine

protocol ProductListViewControllerDelegate: AnyObject {
    func productListViewController(_ productListViewController: ProductListViewController,
                                   didSelect productItem: ProductListItem)
}

final class ProductListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadFailedStackView: UIStackView!
    @IBOutlet weak var loadFailedLabel: UILabel!
    @IBOutlet weak var loadFailedRetryButton: UIButton!
    
    enum Strings {
        static let productItemCellID: String = "productItemCellID"
    }
    
    private let viewModel: ProductListViewModelType
    private var cancellables: Set<AnyCancellable> = []
    private var productListItems: [ProductListItem]?
    
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
        
        setupTableView()
        fetchProductList()
    }
    
    private func setupDynamicUI() {
        title = viewModel.title
    }
    
    public func refreshContent() {
        tableView.reloadData()
    }
    
    private func setupTableView() {
        let cellNib = UINib(nibName: String(describing: ProductListTableViewCell.self), bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: Strings.productItemCellID)
    }
    
    private func fetchProductList() {
        viewModel.fetchProductList()
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .loading:
                    self.view.showLoadingHUD(type: .loading, withFader: false)
                case .success(let productList):
                    self.view.hideLoadingHUD() {
                        guard let productList = productList else {
                            self.presentFetchError(.unexpectedResponse)
                            return
                        }
                        self.productListItems = productList.resultsLite.items
                        self.tableView.reloadData()
                        self.tableView.alpha = 1 // TODO: Animation
                    }
                case .failure(let error):
                    self.view.hideLoadingHUD() {
                        self.setLoadFailureHidden(false)
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
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in self.fetchProductList() }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func didTapRetry() {
        setLoadFailureHidden(true) {
            self.fetchProductList()
        }
    }
}

extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productListItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let productListItems = productListItems,
              indexPath.item < productListItems.count,
              let cell = tableView.dequeueReusableCell(withIdentifier: Strings.productItemCellID,
                                                       for: indexPath) as? ProductListTableViewCell else {
            fatalError("Could not dequeue cell of type: \(ProductListTableViewCell.self) with identifier: \(Strings.productItemCellID)")
        }
        
        let productListItem = productListItems[indexPath.item]
        cell.update(with: ProductListTableViewCellViewModel(with: productListItem,
                                                            isLiked: viewModel.isLiked(productId: productListItem.code8)))
        return cell
    }
}

extension ProductListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ProductListTableViewCell,
              let productListItem = productListItems?[indexPath.item] else {
            return
        }
        
        delegate?.productListViewController(self, didSelect: productListItem)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
