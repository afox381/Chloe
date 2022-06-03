import XCTest

class ChloeSnapshotTests: XCTestCase {
    
    private let shouldRecord: Bool = false

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testEmptyView() throws {
        let view = UIView()
        view.backgroundColor = .red
        view.frame = CGRect(x: 0, y: 0, width: 320, height: 200)
        assertLocalisedView(matching: view, record: shouldRecord)
    }
}
