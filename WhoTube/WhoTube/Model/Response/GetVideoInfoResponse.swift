//
//  GetVideoInfoResponse.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/5.
//

import SwiftyJSON

struct GetVideoInfoResponse: BaseResponse {
    var data: VideoList
    
    init(_ json: JSON) {
        data = VideoList(json)
    }
}
