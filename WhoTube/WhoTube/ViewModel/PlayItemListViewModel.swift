//
//  PlayItemListViewModel.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/4.
//

import RxRelay
import RxSwift
import SwiftyJSON

class PlayItemListViewModel: BaseViewModel {
    let InitItemCount = 30
    let NextItemCount = 20
    
    var playItemListData: PlayItemList?
    var ChannelsListData: ChannelsList?
    let playItemList = BehaviorRelay<[PlayItem]>(value: [])
    let title = BehaviorRelay<String>(value: "")
    
    func getInitData() {
        manageActivityIndicator.accept(true)
        
        Observable.zip(ApiProvider.shared.observe(YoutubeDataService.getPlaylistItems(maxResults: InitItemCount, nextPageToken: nil)),
                       ApiProvider.shared.observe(YoutubeDataService.getChannelInfo))
            .subscribe(onNext: { [weak self] event1, event2 in
                self?.manageActivityIndicator.accept(false)
                switch(event1, event2) {
                case let (.next(res1), .next(res2)):
                    var playListData = GetPlayListItemsResponse(JSON(res1)).data
                    let channelInfo = GetChannelsResponse(JSON(res2)).data
                    playListData.items.indices.forEach { index in
                        playListData.items[index].updateOwnerThumbnail(channelInfo.items.first?.snippet.thumbnails)
                    }
                    
                    self?.playItemListData = playListData
                    self?.ChannelsListData = channelInfo
                    self?.playItemList.accept(playListData.items)
                    self?.title.accept(playListData.items.first?.snippet.channelTitle ?? "")
                    
                default:
                    //error handle
                    break
                }
        }).disposed(by: disposeBag)
    }
    
    func fetchNextPage() {
        guard let token = playItemListData?.nextPageToken, !token.isEmpty else { return }
        
        manageActivityIndicator.accept(true)
        
        ApiProvider.shared.request(YoutubeDataService.getPlaylistItems(maxResults: NextItemCount, nextPageToken: token))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                let playListData = GetPlayListItemsResponse(JSON(res)).data
                var newItems = playListData.items
                // append owner image
                if let channelInfo = self?.ChannelsListData {
                    newItems.indices.forEach { index in
                        newItems[index].updateOwnerThumbnail(channelInfo.items.first?.snippet.thumbnails)
                    }
                }
        
                var playListItems = self?.playItemList.value
                // merge items
                playListItems?.append(contentsOf: newItems)
                if let playListItems = playListItems {
                    self?.playItemList.accept(playListItems)
                }
                
                // update next page
                self?.playItemListData?.updateNextPageToken(token: playListData.nextPageToken)
                
            }).disposed(by: disposeBag)
    }
}
