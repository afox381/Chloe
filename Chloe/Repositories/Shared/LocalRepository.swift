import Foundation
import Combine

class LocalRepository {
    private let localFilename: String
    
    init(localFilename: String) {
        self.localFilename = localFilename
    }
    
    private var documentUrl: URL {
        FileManager.default.documentsDirectory.appendingPathComponent(localFilename)
    }
    
    func storeItem<T>(_ item: T) -> [T]? {
        let readArray = NSMutableArray(contentsOf: documentUrl) ?? NSMutableArray()
        let oldArray = readArray
        if !readArray.contains(item) {
            readArray.add(item)
            return readArray.write(to: documentUrl, atomically: true) ? readArray as? [T] : oldArray as? [T]
        } else {
            return readArray as? [T]
        }
    }
    
    func removeItem<T>(_ item: T) -> [T]? {
        let readArray = NSMutableArray(contentsOf: documentUrl) ?? NSMutableArray()
        let oldArray = readArray
        if readArray.contains(item) {
            readArray.remove(item)
            return readArray.write(to: documentUrl, atomically: true) ? readArray as? [T] : oldArray as? [T]
        } else {
            return readArray as? [T]
        }
    }
    
    func storedItems<T>() -> [T] {
        guard let readArray = NSArray(contentsOf: documentUrl) else { return [] }
        return readArray as? [T] ?? []
    }
    
    func removeLocalFile() -> Bool {
        do {
            try FileManager.default.removeItem(at: documentUrl)
            return true
        } catch {
            return false
        }
    }
}
