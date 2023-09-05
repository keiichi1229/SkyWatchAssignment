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
