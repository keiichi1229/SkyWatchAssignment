//
//  BaseViewModel.swift
//  WhoTube
//
//  Created by Raymondting on 2023/8/31.
//

import RxSwift
import RxCocoa

class BaseViewModel {
    
    let disposeBag = DisposeBag()

    //title, message
    let presentAlert = PublishRelay<(String,String)>()

    let manageActivityIndicator = PublishRelay<Bool>()
    
    init() {}
}
