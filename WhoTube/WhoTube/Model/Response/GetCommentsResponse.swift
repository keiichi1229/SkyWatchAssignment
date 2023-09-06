//
//  GetCommentsResponse.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/5.
//

import SwiftyJSON

struct GetCommentsResponse: BaseResponse {
    var data: CommentThreadList
    
    init(_ json: JSON) {
        data = CommentThreadList(json)
    }
}
