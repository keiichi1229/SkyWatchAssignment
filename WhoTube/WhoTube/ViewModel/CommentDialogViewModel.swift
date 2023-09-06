//
//  CommentDialogViewModel.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/5.
//

import RxRelay
import RxSwift
import SwiftyJSON

class CommentDialogViewModel: BaseViewModel {
    let NextItemCount = 50
    var commentThreadData: CommentThreadList?
    let title = BehaviorRelay<String>(value: "")
    let commentItems = BehaviorRelay<[CommentThread]>(value: [])
    
    func getInitComments(videoId: String) {
        ApiProvider.shared.request(YoutubeDataService.getComments(videoId: videoId,
                                                                  maxResults: NextItemCount,
                                                                  nextPageToken: nil))
            .subscribe(onSuccess: {[weak self] res in
                let result = GetCommentsResponse(JSON(res)).data
                self?.commentThreadData = result
                self?.commentItems.accept(result.items)
            }, onFailure: {[weak self] err in
                self?.presentAlert.accept(("", err.msg))
            }).disposed(by: disposeBag)
    }
    
    func fetchNextComments() {
        guard let token = commentThreadData?.nextPageToken,
              !token.isEmpty,
              let videoId = commentThreadData?.items.first?.snippet.videoId else { return }
        
        ApiProvider.shared.request(YoutubeDataService.getComments(videoId: videoId,
                                                                  maxResults: NextItemCount,
                                                                  nextPageToken: token))
            .subscribe(onSuccess: {[weak self] res in
                guard let self = self else { return }
                let commentThreadData = GetCommentsResponse(JSON(res)).data
                self.commentThreadData?.updatePageToken(commentThreadData.nextPageToken)
                
                var items = self.commentItems.value
                items.append(contentsOf: commentThreadData.items)
                self.commentItems.accept(items)
            }, onFailure: {[weak self] err in
                self?.presentAlert.accept(("", err.msg))
            }).disposed(by: disposeBag)
    }
}
