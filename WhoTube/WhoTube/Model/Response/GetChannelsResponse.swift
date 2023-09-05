//
//  GetChannelsResponse.swift
//  WhoTube
//
//  Created by Raymondting on 2023/8/31.
//

import SwiftyJSON

struct GetChannelsResponse: BaseResponse {
    var data: ChannelsList
    
    init(_ json: JSON) {
        data = ChannelsList(json)
    }
}

