import UIKit

protocol CarouselViewDelegate: AnyObject {
    func carouselViewDidBeginUpdating(_ carouselView: CarouselView)
    func carouselViewDidEndUpdating(_ carouselView: CarouselView)
    func carouselViewDidTap(_ carouselView: CarouselView, currentTile: Int)
}

final class CarouselView: UIView {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var titleContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    enum Constants {
        static let numberOfScreenWidths: CGFloat = 14000 // Max size before scrollview breaks
        static let contentWidth: CGFloat = UIScreen.main.bounds.width * numberOfScreenWidths
        static let startOffsetX: CGFloat = contentWidth / 2
    }

    weak var delegate: CarouselViewDelegate?
    var viewModel: CarouselViewModel!

    private var tileViews: [CarouselTileView] = []
    private var previousScrollContentOffsetX: CGFloat = 0
    private var currentFaderView: UIView?
    private var didTransitionToFill = false
    private var currentPageIndex: Int { viewModel.pageIndex(for: scrollView.contentOffset.x) }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard tileViews.isEmpty else { return }
        setup()
    }

    private func setup() {
        contentViewWidthConstraint.constant = Constants.contentWidth
        scrollView.layoutIfNeeded()
        previousScrollContentOffsetX = Constants.startOffsetX
        scrollView.contentOffset = CGPoint(x: Constants.startOffsetX, y: 0)
        setupContent()
        viewModel.updateTileViews(delta: 0)
        setupPageControl()
        refreshPageControl()
        setTitleHidden(false, title: viewModel.attributedTitle(index: currentPageIndex))
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = viewModel.tileViewModels.count
        pageControl.currentPageIndicatorTintColor = UIColor(named: "ChloeBeige")
        pageControl.tintColor = .white
    }

    private func setupContent() {
        viewModel.tileViewModels.forEach { tileViewModel in
            let tileView = CarouselTileView.loadFromNib()
            tileView.viewModel = tileViewModel
            
            tileView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(tileView)
            NSLayoutConstraint.activate([
                tileView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                tileView.topAnchor.constraint(equalTo: containerView.topAnchor),
                tileView.widthAnchor.constraint(equalToConstant: frame.width),
                tileView.heightAnchor.constraint(equalToConstant: frame.height * 0.8)
            ])
            
            tileView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            tileViews.append(tileView)
        }
    }
    
    private func refreshPageControl() {
        pageControl.currentPage = currentPageIndex
    }
    

    @IBAction private func didTap() {
        delegate?.carouselViewDidTap(self, currentTile: currentPageIndex)
    }
}

// MARK: - Title

extension CarouselView {
    private func setTitleHidden(_ isHidden: Bool, title: NSAttributedString? = nil) {
        if let title = title {
            titleLabel.attributedText = title
        }
        
        let targetAlpha: CGFloat = isHidden ? 0 : 1
        UIView.animate(withDuration: 0.2) {
            self.titleContainerView.alpha = targetAlpha
        }
    }
}

// MARK: - Transition animation

extension CarouselView {
    func transitionTileToFill(completion: @escaping () -> Void) {
        guard !didTransitionToFill else { return }
        
        isUserInteractionEnabled = false
        let tileView = tileViews[currentPageIndex]
        let faderView = UIView()
        faderView.backgroundColor = viewModel.backgroundColour(for: currentPageIndex)
        faderView.alpha = 0
        tileViews[currentPageIndex].add(child: faderView)
        currentFaderView = faderView
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            tileView.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
            faderView.alpha = 1.0
        }, completion: { _ in
            self.isUserInteractionEnabled = true
            completion()
        })
        
        didTransitionToFill = true
    }
    
    func transitionTileFromFill(completion: (() -> Void)? = nil) {
        guard didTransitionToFill, let faderView = currentFaderView else { return }
        
        isUserInteractionEnabled = false
        let tileView = tileViews[currentPageIndex]
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            tileView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            faderView.alpha = 0.0
        }, completion: { _ in
            faderView.removeFromSuperview()
            self.currentFaderView = nil
            self.isUserInteractionEnabled = true
            completion?()
        })
        
        didTransitionToFill = false
    }
}

extension CarouselView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.updateTileViews(delta: previousScrollContentOffsetX - scrollView.contentOffset.x)
        previousScrollContentOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.carouselViewDidBeginUpdating(self)
        setTitleHidden(true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.carouselViewDidEndUpdating(self)
        refreshPageControl()
        setTitleHidden(false, title: viewModel.attributedTitle(index: currentPageIndex))
    }
}
