import XCTest
import SwiftUI
@testable import Chloe

class CategorySnapshotTests: XCTestCase {
    private let shouldRecord: Bool = false

    override func setUp() {
    }

    override func tearDown() {
    }

    func testCategoryController() {
        let controller = CategoryViewController(viewModel: CategoryViewModel())
        let nav = navigationViewController(with: controller)
        assertLocalisedVCInNavigation(matching: nav, record: shouldRecord)
    }
}
