import XCTest
import SwiftUI
@testable import Chloe

class DetailSnapshotTests: XCTestCase {
    private let shouldRecord: Bool = false
    private let productDetailRepository = MockProductDetailRepository()

    override func setUp() {
    }

    override func tearDown() {
    }

    func testSuccess() {
        let productService = ProductService(code8: "code8",
                                            image: UIImage(named: "testImage")!,
                                            productDetailRepository: productDetailRepository)
        let hostingController = UIHostingController(rootView: ProductView(productService: productService))
        let nav = navigationViewController(with: hostingController)
        wait(for: .main, atleast: 0.5)
        
        assertLocalisedVCInNavigation(matching: nav, record: shouldRecord)
    }
    
    func testLoading() {
        productDetailRepository.isLoading = true
        let productService = ProductService(code8: "code8",
                                            image: UIImage(named: "testImage")!,
                                            productDetailRepository: productDetailRepository)
        let hostingController = UIHostingController(rootView: ProductView(productService: productService))
        let nav = navigationViewController(with: hostingController)
        wait(for: .main, atleast: 0.5)
        
        assertLocalisedVCInNavigation(matching: nav, record: shouldRecord)
    }
    
    func testFailure() {
        productDetailRepository.didFail = true
        let productService = ProductService(code8: "code8",
                                            image: UIImage(named: "testImage")!,
                                            productDetailRepository: productDetailRepository)
        let hostingController = UIHostingController(rootView: ProductView(productService: productService))
        let nav = navigationViewController(with: hostingController)
        wait(for: .main, atleast: 0.5)
        
        assertLocalisedVCInNavigation(matching: nav, record: shouldRecord)
    }
}
