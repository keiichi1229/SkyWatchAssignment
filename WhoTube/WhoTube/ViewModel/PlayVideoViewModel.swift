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
    
    let playerVars: [String: Any] = [
        "autoplay": 1,
        "controls": 1,
        "rel": 0,
        "modestbranding": 1,
        "playsinline": 1
    ]
    
    let title = BehaviorRelay<String>(value: "")
    let playVideoItem = BehaviorRelay<PlayItem?>(value: nil)
    let videoDescription = BehaviorRelay<String>(value: "")
    var apiProvider = ApiProvider.shared
    
    init(withPlayVideoItem playItem: PlayItem) {
        title.accept(playItem.snippet.title)
        playVideoItem.accept(playItem)
    }
    
    func getVideoInfo(videoId: String) {
        apiProvider.request(YoutubeDataService.getVideoInfo(videoId: videoId))
            .subscribe(onSuccess: { [weak self] res in
                let videoItem = GetVideoInfoResponse(JSON(res))
                self?.videoDescription.accept(videoItem.data.items.first?.snippet.localized.description ?? "")
        }, onFailure: { [weak self] err in
            self?.presentAlert.accept(("", err.msg))
        }).disposed(by: disposeBag)
    }
}
