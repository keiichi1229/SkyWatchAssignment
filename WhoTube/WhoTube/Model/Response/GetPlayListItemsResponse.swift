//
//  GetPlayListItemsResponse.swift
//  WhoTube
//
//  Created by Raymondting on 2023/8/31.
//

import SwiftyJSON

struct GetPlayListItemsResponse: BaseResponse {
    var data: PlayItemList
    
    init(_ json: JSON) {
        data = PlayItemList(json)
    }
}
