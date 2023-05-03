import UIKit

final class ProductListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    public func update(with viewModel: ProductListCollectionViewCellViewModelType) {
        titleLabel.attributedText = viewModel.title
        priceLabel.attributedText = viewModel.price
        
        if let imageUrl = viewModel.imageUrl {
            imageView.setImage(fromUrl: imageUrl)
        }
        
        likeImageView.isHidden = !viewModel.isLiked
    }
}
