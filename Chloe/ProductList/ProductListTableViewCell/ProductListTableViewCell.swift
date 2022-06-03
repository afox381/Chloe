import UIKit

final class ProductListTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    
    var loadedImage: UIImage? { thumbnailImageView.image }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
    
    public func update(with viewModel: ProductListTableViewCellViewModelType) {
        titleLabel.attributedText = viewModel.title
        priceLabel.attributedText = viewModel.price
        
        if let imageUrl = viewModel.imageUrl {
            thumbnailImageView.image(fromUrl: imageUrl)
        }
        
        likeImageView.isHidden = !viewModel.isLiked
    }
}
