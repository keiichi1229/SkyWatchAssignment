//
//  SearchVideoViewModel.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/6.
//

import RxRelay
import RxSwift
import SwiftyJSON

class SearchVideoViewModel: BaseViewModel {
    let originalItems: [PlayItem]
    let searchTerm = BehaviorRelay<String>(value: "")
    let resultItems = BehaviorRelay<[PlayItem]>(value: [])
    
    init(withPlayVideoItems playItem: [PlayItem]) {
        originalItems = playItem
        super.init()
        bind()
    }
    
    private func bind() {
        searchTerm.subscribe(onNext: {[weak self] text in
            guard let self = self else { return }
            let filterItems = self.originalItems.filter { $0.snippet.title.lowercased().contains(text.lowercased()) }
            self.resultItems.accept(filterItems)
        }).disposed(by: disposeBag)
    }
}
