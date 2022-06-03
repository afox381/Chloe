import UIKit
import Combine

protocol ProductListViewControllerDelegate: AnyObject {
    func productListViewController(_ productListViewController: ProductListViewController,
                                   didSelect productItem: ProductListItem)
    func productListViewControllerDidClose()
}

final class ProductListViewController: UIViewController {
    @IBOutlet fileprivate var tableView: UITableView!
    
    enum Strings {
        static let productItemCellID: String = "productItemCellID"
    }
    
    private let viewModel: ProductListViewModelType
    private var cancellables: Set<AnyCancellable> = []
    private var productList: [ProductListItem]?
    
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
        fetchCharacters()
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
    
    private func fetchCharacters() {
        viewModel.fetchProductList()
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .loading:
                    print("Show loading screen")
                case .success(let characterList):
                    guard let characterList = characterList else {
                        self.presentFetchError(.unexpectedResponse)
                        return
                    }
                    self.productList = characterList
                    self.tableView.reloadData()
                case .failure(let error):
                    self.presentFetchError(error as? RepositoryError)
                case .inactive:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func presentFetchError(_ error: RepositoryError?) {
        let alert = UIAlertController(title: "Fetch Failed", message: "Characters failed to download. Please check your internet connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in self.fetchCharacters() }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func didTapClose() {
        delegate?.productListViewControllerDidClose()
    }
}

extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let productList = productList,
              indexPath.item < productList.count,
              let cell = tableView.dequeueReusableCell(withIdentifier: Strings.productItemCellID,
                                                       for: indexPath) as? ProductListTableViewCell else {
            fatalError("Could not dequeue cell of type: \(ProductListTableViewCell.self) with identifier: \(Strings.productItemCellID)")
        }
        
        let productListItem = productList[indexPath.item]
        cell.update(with: ProductListTableViewCellViewModel(with: productListItem,
                                                            isLiked: viewModel.isLiked(productId: productListItem.id)))
        return cell
    }
}

extension ProductListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ProductListTableViewCell,
              let productListItem = productList?[indexPath.item] else {
            return
        }
        
        delegate?.productListViewController(self, didSelect: productListItem)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
