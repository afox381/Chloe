import UIKit
import Combine

final class ProductDetailViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var quotesStackView: UIStackView!
    @IBOutlet weak var likeButton: UIButton!
    
    private let viewModel: ProductDetailViewModelType
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: ProductDetailViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.name
        occupationLabel.text = "Occupation(s): \(viewModel.occupation.joined(separator: ", "))"
        statusLabel.text = "Status: \(viewModel.status)"
        imageView.image = viewModel.image
        imageView.applySurroundingShadow()
        
        refreshIsLiked()
        fetchProductDetails()
    }
    
    private func fetchProductDetails() {
        viewModel.fetchProductDetails()
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    print("Show loading screen")
                case .success(let productDetails):
                    guard let productDetails = productDetails else {
                        self.presentFetchError(.unexpectedResponse)
                        return
                    }
                    
                    
                    
                    
                    
                    
                case .failure(let error):
                    self.presentFetchError(error as? RepositoryError)
                case .inactive:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func refreshIsLiked() {
        let image = UIImage(systemName: viewModel.isLiked ? "heart.fill" : "heart")?.withTintColor(.systemPink)
        likeButton.setImage(image, for: .normal)
    }
    
    @IBAction private func didToggleLike() {
        viewModel.toggleLike()
        refreshIsLiked()
    }
    
    private func presentFetchError(_ error: RepositoryError?) {
        let alert = UIAlertController(title: "Fetch Failed", message: "Character details failed to download. Please check your internet connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in self.fetchProductDetails() }))
        present(alert, animated: true, completion: nil)
    }
    
    private func presentReviewError(_ error: RepositoryError?) {
        let alert = UIAlertController(title: "Review Failed", message: "Could not post your review at this time. Please check your internet connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func presentReviewSuccess() {
        let alert = UIAlertController(title: "Review Posted", message: "Thank you for your review.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
