//
//  PlayVideoViewModel.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/5.
//

import RxRelay
import RxSwift
import SwiftyJSON

class PlayVideoViewModel: BaseViewModel {
    let title = BehaviorRelay<String>(value: "")
    let playVideoItem = BehaviorRelay<PlayItem?>(value: nil)
    
    init(withPlayVideoItem playItem: PlayItem) {
        title.accept(playItem.snippet.title)
        playVideoItem.accept(playItem)
    }
    
}
