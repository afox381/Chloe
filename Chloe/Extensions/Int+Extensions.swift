import Foundation

extension Int {
    func formattedPrice(for countryCode: String = "en") -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: countryCode == "en" ? "en_UK" : countryCode)
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: self as NSNumber) ?? ""
    }
}
