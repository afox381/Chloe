import Foundation

extension String {

    func attributed(with attributes: [NSAttributedString.Key: Any]? = nil) -> NSAttributedString {
        .init(string: self, attributes: attributes)
    }

    func attributed(with attributes: StringAttributes) -> NSAttributedString {
        attributed(with: attributes.dictionary)
    }

    var titlecased: String {
        replacingOccurrences(of: "([A-Z]|[0-9])", with: " $1", options: .regularExpression, range: self.range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
    }

    var delimitOnSlash: String {
        replacingOccurrences(of: "(\\s*)\\/(\\s*|$)", with: " | ", options: .regularExpression)
    }
    
    var participantsDelimiter: String {
        replacingOccurrences(of: "(\\s{1,})(vs|v|@|v\\.s\\.|,|-)(\\s{1,}|$)", with: " * ", options: .regularExpression)
        
    }
    
    func eventParticipants() -> [String] {
        var tmpParticipants: [String] = [String]()
        
        let participants = participantsDelimiter.components(separatedBy: " * ").filter {
            !$0.isEmpty
        }
        
        tmpParticipants.append(contentsOf: participants)

        return tmpParticipants
    }
}
