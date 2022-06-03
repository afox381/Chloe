import UIKit

extension UIDevice {
    enum ModelType {
        case iPhoneXr
        case iPhoneX
        case iPhone5
        case iPhone678
        case iPhone678Plus
        case iPad
        case other
    }
    
    var modelName: String {
        // DO NOT use the userInterfaceIdiom property to identify the device type
        //
        // The iPhone app could be installed on an iPad, so in that case the userInterfaceIdiom will return the UIUserInterfaceIdiomPhone, too.
        //
        // The right way to get the machine name is via uname
        // See https://goo.gl/XkHx32
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    var modelType: ModelType {
        if isIPhoneXr {
            return .iPhoneXr
        } else if isIPhoneX {
            return .iPhoneX
        } else if isIPhone5 {
            return .iPhone5
        } else if isIPhone678 {
            return .iPhone678
        } else if isIPhone678Plus {
            return .iPhone678Plus
        } else if UIDevice.isIPad {
            return .iPad
        } else {
            return .other
        }
    }
    
    var hasNotch: Bool {
        return isIPhoneXr || isIPhoneX
    }
    
    var isIPhoneX: Bool {
        switch UIScreen.main.bounds.height {
        case 812:
            return true
        default:
            return false
        }
    }
    
    var isIPhoneXr: Bool {
        switch UIScreen.main.bounds.height {
        case 896:
            return true
        default:
            return false
        }
    }
    
    var isIPhone5: Bool {
        switch UIScreen.main.bounds.width {
        case 320:
            return true
        default:
            return false
        }
    }
    
    var isIPhone678: Bool {
        switch UIScreen.main.bounds.size {
        case CGSize(width: 375, height: 667):
            return true
        default:
            return false
        }
    }
    
    var isIPhone678Plus: Bool {
        switch UIScreen.main.bounds.size {
        case CGSize(width: 414, height: 736):
            return true
        default:
            return false
        }
    }
    
    static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /*
         Total available capacity in bytes for "Important" resources, including space expected to be cleared by purging non-essential and cached resources. "Important" means something that the user or application clearly expects to be present on the local system, but is ultimately replaceable. This would include items that the user has explicitly requested via the UI, and resources that an application requires in order to provide functionality.
         Examples: A video that the user has explicitly requested to watch but has not yet finished watching or an audio file that the user has requested to download.
         This value should not be used in determining if there is room for an irreplaceable resource. In the case of irreplaceable resources, always attempt to save the resource regardless of available capacity and handle failure as gracefully as possible.
         */
    static var freeDiskSpaceInBytes: Int64 {
        if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
            return space
        } else {
            return 0
        }
    }
}
