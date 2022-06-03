import UIKit

final class ProductListTableViewCell: UITableViewCell {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var nicknameLabel: UILabel!
    @IBOutlet private var portrayedLabel: UILabel!
    @IBOutlet private var thumbnailImageView: UIImageView!
    @IBOutlet private var likeImageView: UIImageView!
    
    var loadedImage: UIImage? { thumbnailImageView.image }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
    
    public func update(with viewModel: ProductListTableViewCellViewModelType) {
        nameLabel.text = "Name: \(viewModel.name)"
        nicknameLabel.text = "Nickname: \(viewModel.nickname)"
        portrayedLabel.text = "Portrayed by: \(viewModel.portrayed)"
        
        if let imageUrl = viewModel.imageUrl {
            thumbnailImageView.image(fromUrl: imageUrl)
        }
        
        likeImageView.isHidden = !viewModel.isLiked
    }
}
