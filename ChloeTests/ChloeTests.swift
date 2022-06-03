import XCTest
@testable import Chloe

class ChloeTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testLikesLocalRepository() throws {
        let repository = LikesRepository(likesFilename: "test.filename")

        // Add our first like
        repository.toggleLike(15)
        XCTAssertTrue(repository.isLiked(15))
        
        // Add a second like
        repository.toggleLike(23)
        XCTAssertTrue(repository.isLiked(15))
        XCTAssertTrue(repository.isLiked(23))
        
        // Remove our first like
        repository.toggleLike(15)
        XCTAssertFalse(repository.isLiked(15))
        XCTAssertTrue(repository.isLiked(23))
        
        // Remove our second like
        repository.toggleLike(23)
        XCTAssertFalse(repository.isLiked(15))
        XCTAssertFalse(repository.isLiked(23))

        XCTAssertTrue(repository.removeLocalFile())
    }
}
