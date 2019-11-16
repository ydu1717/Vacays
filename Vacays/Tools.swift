
import UIKit
import Foundation


// MARK: -
let SCREEN_HEIGHT = CGFloat(UIScreen.main.bounds.height)
let SCREEN_WIDTH  = CGFloat(UIScreen.main.bounds.width)
let StatusHeight  = UIApplication.shared.statusBarFrame.size.height
let BottomSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
let NavigationHeight = (BottomSafeAreaHeight == 0 ? 64 : 88)


let GWID       = "GWID_Key"
let UserID     = "Userid_Key"


extension UIColor {
    
    
    class var cBackGroupColor: UIColor {
        return UIColor(red:0.937, green:0.937, blue:0.957, alpha: 1.000)
    }
    
    class var btnColor: UIColor {
        return UIColor(red:0.141, green:0.835, blue:0.847, alpha: 1.000)
    }
    
    class var cuigreenColor : UIColor {
        return UIColor(red:0.212, green:0.827, blue:0.643, alpha: 1.000)
    }
    
}

// MARK: - UIView + extension
extension UIView {
    
    static private let SCREEN_SCALE = UIScreen.main.scale
    
    private func getPixintegral(pointValue: CGFloat) -> CGFloat {
        return round(pointValue * UIView.SCREEN_SCALE) / UIView.SCREEN_SCALE
    }
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(x) {
            self.frame = CGRect.init(
                x: getPixintegral(pointValue: x),
                y: self.y,
                width: self.width,
                height: self.height
            )
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(y) {
            self.frame = CGRect.init(
                x: self.x,
                y: getPixintegral(pointValue: y),
                width: self.width,
                height: self.height
            )
        }
    }
    
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(width) {
            self.frame = CGRect.init(
                x: self.x,
                y: self.y,
                width: getPixintegral(pointValue: width),
                height: self.height
            )
        }
    }
    
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set (height) {
            self.frame = CGRect.init(
                x: self.x,
                y: self.y,
                width: self.width,
                height: getPixintegral(pointValue: height)
            )
        }
    }
    
    public var bottom: CGFloat {
        get {
            return self.y + self.height
        }
        set(bottom) {
            self.y = bottom - self.height
        }
    }
    
    public var right: CGFloat {
        get {
            return self.x + self.width
        }
        set (right) {
            self.x = right - self.width
        }
    }
    
    public var left: CGFloat {
        get {
            return self.x
        }
        set(left) {
            self.x = left
        }
    }
    
    public var top: CGFloat {
        get {
            return self.y
        }
        set(top) {
            self.y = top
        }
    }
    
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(centerX) {
            self.center = CGPoint.init(
                x: getPixintegral(pointValue: centerX),
                y: self.center.y
            )
        }
    }
    
    public var centerY: CGFloat {
        get {
            return self.center.y
        }
        set (centerY) {
            self.center = CGPoint.init(x: self.center.x, y: getPixintegral(pointValue: centerY))
        }
    }
    
}


