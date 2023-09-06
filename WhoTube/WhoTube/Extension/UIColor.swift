//
//  UIColor.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/5.
//

import UIKit

extension UIColor {
    open class func rgb(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(displayP3Red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
    
    open class var lightGray242: UIColor {
        return .rgb(r: 242, g: 242, b: 242)
    }
}
