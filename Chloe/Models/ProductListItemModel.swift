import Foundation

struct ProductListItem: Codable {
    let id: String
    let name: String
    let birthday: String
    let occupation: [String]
    let img: String
    let status: String
    let appearance: [Int]
    let nickname: String
    let portrayed: String

    enum CodingKeys: String, CodingKey {
        case id, name, birthday, occupation, img, status, appearance, nickname, portrayed
    }
}
