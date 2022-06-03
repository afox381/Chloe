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
    
    enum Metrics {
        static let alphaStartPct: CGFloat = 0.3
        static let alphaEndPct: CGFloat = 0.7
        static let zTranslationDelta: CGFloat = 250
    }

    weak var delegate: CarouselViewDelegate?
    var viewModel: CarouselViewModel!

    private var tileViews: [CarouselTileView] = []
    private var previousScrollContentOffsetX: CGFloat = 0
    private var currentFaderView: UIView?

    private var tilePct: CGFloat {
        get {
            guard scrollView != nil else { return 0 }
            return max(min(scrollView.contentOffset.x / (contentViewWidthConstraint.constant - scrollView.frame.width), 1), 0)
        }
        set {
            guard scrollView != nil else { return }
            scrollView.contentOffset = CGPoint(x: (newValue * CGFloat(viewModel.carouselItems.count - 1)) * scrollView.frame.width, y: 0)
        }
    }
    
    private var currentPageIndex: Int {
        Int((scrollView.contentOffset.x + (scrollView.frame.width / 2)) / scrollView.frame.width)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard tileViews.isEmpty else { return }
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setup() {
        contentViewWidthConstraint.constant = CGFloat(viewModel.carouselItems.count) * frame.width
        scrollView.layoutIfNeeded()
        tilePct = 0
        previousScrollContentOffsetX = scrollView.contentOffset.x
        setupContent()
        updateViews(delta: 0)
        setupPageControl()
        refreshPageControl()
        setTitleHidden(false, title: viewModel.attributedTitle(index: currentPageIndex))
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = viewModel.carouselItems.count
        pageControl.currentPageIndicatorTintColor = UIColor(named: "ChloeBeige")
        pageControl.tintColor = .white
    }

    private func setupContent() {
        var offsetX: CGFloat = 0
        var pct: CGFloat = 0.5
        viewModel.carouselItems.forEach { carouselItem in
            let tileView = CarouselTileView.loadFromNib()
            tileView.viewModel = CarouselTileViewModel(imageName: carouselItem.imageName, pct: pct)
            
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

            offsetX += frame.width
            pct += 0.5
        }
    }
    
    private func refreshPageControl() {
        pageControl.currentPage = currentPageIndex
    }
    
    private func updateTileView(_ tileView: CarouselTileView) {
        let boundedPct = min(max(tileView.pct, 0), 1)
        let shiftedPct = (boundedPct * 2) - 1
        let curvedPct = sin((shiftedPct * 30).inRadians)
        
        let xTranslation = curvedPct * (UIScreen.main.bounds.width * 2)
        let zTranslation: CGFloat = abs(curvedPct) * 100
        var transform = CATransform3D.Identity.Perspective.low
        transform = CATransform3DTranslate(transform, xTranslation, 0, zTranslation)
        transform = CATransform3DRotate(transform, (curvedPct * -25).inRadians, 0, 1, 0)
        tileView.layer.sublayerTransform = transform
        tileView.alpha = alpha(for: boundedPct)
    }

    private func alpha(for pct: CGFloat) -> CGFloat {
        let alpha: CGFloat
        switch pct {
        case 0...Metrics.alphaStartPct:
            alpha = min(abs(1 - ((Metrics.alphaStartPct - pct) / Metrics.alphaStartPct)), 1)
        case Metrics.alphaEndPct..<1.0:
            alpha = min(abs(1 - ((pct - Metrics.alphaEndPct) / (1 - Metrics.alphaEndPct))), 1)
        case 1.0...999, -999..<0.0:
            alpha = 0
        default:
            alpha = 1
        }
        return alpha
    }
    
    private func updateViews(delta: CGFloat) {
        tileViews.forEach { tileView in
            tileView.pct += delta / (scrollView.frame.width * 2)
            updateTileView(tileView)
        }
    }
    
    private func setTitleHidden(_ isHidden: Bool, title: NSAttributedString? = nil) {
        if let title = title {
            titleLabel.attributedText = title
        }
        
        let targetAlpha: CGFloat = isHidden ? 0 : 1
        UIView.animate(withDuration: 0.2) {
            self.titleContainerView.alpha = targetAlpha
        }
    }
    
    func transitionTileToFill(completion: @escaping () -> Void) {
        if isTransitioned {
            transitionTileFromFill {
                completion()
            }
            return
        }
        let tileView = tileViews[currentPageIndex]
        let faderView = UIView()
        faderView.backgroundColor = viewModel.carouselItems[currentPageIndex].backgroundColour
        faderView.alpha = 0
        tileViews[currentPageIndex].add(child: faderView)
        currentFaderView = faderView
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            tileView.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
            faderView.alpha = 1.0
        }, completion: { _ in
            completion()
        })
        
        isTransitioned = true
    }
    
    var isTransitioned = false
    func transitionTileFromFill(completion: @escaping () -> Void) {
        guard let faderView = currentFaderView else { return }
        let tileView = tileViews[currentPageIndex]
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            tileView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            faderView.alpha = 0.0
        }, completion: { _ in
            faderView.removeFromSuperview()
            self.currentFaderView = nil
            completion()
        })
        
        isTransitioned = false
    }
    
    @IBAction private func didTap() {
        delegate?.carouselViewDidTap(self, currentTile: currentPageIndex)
    }
}

extension CarouselView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateViews(delta: previousScrollContentOffsetX - scrollView.contentOffset.x)
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
