import SnapshotTesting
import UIKit
import XCTest

extension XCTestCase {
    func assertLocalisedVCInNavigation(matching subject: UINavigationController,
                                              as snapshotting: Snapshotting<UIViewController, UIImage> = Snapshotting.image,
                                              named name: String? = nil,
                                              record recording: Bool = false,
                                              timeout: TimeInterval = 5,
                                              file: StaticString = #file,
                                              testName: String = #function,
                                              line: UInt = #line) {

        let descriptionFileName = localisedFileName(with: name)

        SnapshotTesting.assertSnapshot(matching: subject,
                                       as: snapshotting,
                                       named: descriptionFileName,
                                       record: recording,
                                       timeout: timeout,
                                       file: file,
                                       testName: testName,
                                       line: line)
    }

    func assertLocalisedView(matching value: UIView,
                                    as snapshotting: Snapshotting<UIView, UIImage> = Snapshotting.image,
                                    named name: String? = nil,
                                    record recording: Bool = false,
                                    timeout: TimeInterval = 5,
                                    file: StaticString = #file,
                                    testName: String = #function,
                                    line: UInt = #line) {

        let descriptionFileName = localisedFileName(with: name)

        SnapshotTesting.assertSnapshot(matching: value,
                                       as: snapshotting,
                                       named: descriptionFileName,
                                       record: recording,
                                       timeout: timeout,
                                       file: file,
                                       testName: testName,
                                       line: line)
    }

    public func navigationViewController(with viewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController()
        navController.pushViewController(viewController, animated: false)
        return navController
    }

    private func localisedFileName(with name: String?) -> String {
        let targetName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        var text = "\(targetName.lowercased())-\(name ?? "")"
        text += locale
        return text
    }

    private var locale: String {
        [Locale.current.languageCode, Locale.current.regionCode]
            .compactMap { $0 }
            .joined(separator: "-")
    }

}
