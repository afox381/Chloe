import Foundation
import Combine

final class LikesRepository: LocalRepository {
    enum Strings {
        static let defaultLikesFilename: String = "likes.list"
    }
    
    let likesFilename: String
    lazy var cachedLikeIds: [String] = storedItems()
    
    init(likesFilename: String = Strings.defaultLikesFilename) {
        self.likesFilename = likesFilename
        super.init(localFilename: Strings.defaultLikesFilename)
    }
    
    @discardableResult
    func toggleLike(_ id: String) -> Bool {
        if let newItems = cachedLikeIds.contains(id) ? removeItem(id) : storeItem(id) {
            cachedLikeIds = newItems
            return true
        } else {
            return false
        }
    }
    
    func isLiked(_ id: String) -> Bool {
        cachedLikeIds.contains(id)
    }
    
    func clearLikes() -> Bool {
        removeLocalFile()
    }
}
