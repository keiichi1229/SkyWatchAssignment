//
//  UIViewController.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/5.
//
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var title: Binder<String?> {
        return Binder(self.base) { viewController, title in
            viewController.title = title
        }
    }
}

extension UIViewController {
    func presentAlert(title: String?, message: String?, callback: (()->Void)?) {
        let alertViewCtrl = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            callback?()
        }
        alertViewCtrl.addAction(okAction)
        
        self.present(alertViewCtrl, animated: true, completion: nil)
    }
}
