//
//  UIApplication.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/1.
//

import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
        // Get connected scenes for iOS 15
        return self.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}
