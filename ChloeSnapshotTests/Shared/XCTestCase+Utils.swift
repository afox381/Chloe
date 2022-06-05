import XCTest

public extension XCTestCase {
    func wait(for queue: DispatchQueue = .main,
              atleast: TimeInterval = 0.2) {
        let exp = expectation(description: "something")
        queue.asyncAfter(deadline: .now() + atleast) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: atleast + 5.0)
    }
}
