//
//  UIFont.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/4.
//

import UIKit

extension UIFont {
    open class func dinProBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DINPro-Bold", size: size) ?? .boldSystemFont(ofSize: size)
    }
    
    open class func dinProMedium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DINPro-Medium", size: size) ?? .systemFont(ofSize: size)
    }
    
    open class func dinPro(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DINPro", size: size) ?? .systemFont(ofSize: size)
    }
}
