import UIKit

extension Int {
    func asPercent(of value: Int) -> Double {
        return Double(self) / Double(value)
    }
}

extension CGFloat {
    var inRadians: CGFloat {
        return (.pi * self) / 180.0
    }
    
    var inDegrees: CGFloat {
        return (180.0 * self) / .pi
    }
}

extension CATransform3D {
    enum Identity {
        enum Perspective {
            static var low: CATransform3D {
                var transform = CATransform3DIdentity
                transform.m34 = -1.0 / 1000
                return transform
            }
            
            static var high: CATransform3D {
                var transform = CATransform3DIdentity
                transform.m34 = -1.0 / 500
                return transform
            }
        }
    }
}

extension CAMediaTimingFunction {
    static var extendedEaseOut: CAMediaTimingFunction {
        let point1 = Float(sin(CGFloat(50).inRadians))
        let point2 = Float(sin(CGFloat(85).inRadians))
        return CAMediaTimingFunction(controlPoints: 0.15, point1, 0.4, point2)
    }
}
