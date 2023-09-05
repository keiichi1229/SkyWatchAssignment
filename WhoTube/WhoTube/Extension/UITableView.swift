//
//  UITableView.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/5.
//

import RxSwift
import RxCocoa
import UIKit

extension UITableView {
    var reachedBottom: Observable<Void> {
        return self.rx.contentOffset
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .flatMap { [weak self] contentOffset -> Observable<Void> in
                guard let self = self else {
                    return Observable.empty()
                }

                let visibleHeight = self.frame.height - self.contentInset.top - self.contentInset.bottom
                let y = contentOffset.y + self.contentInset.top
                let threshold = max(0.0, self.contentSize.height - visibleHeight) // the gap of trigger

                return y > threshold ? Observable.just(()) : Observable.empty()
            }
    }
}

