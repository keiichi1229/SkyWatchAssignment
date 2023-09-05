//
//  BaseResponse.swift
//  WhoTube
//
//  Created by Raymondting on 2023/8/30.
//

import Foundation
import SwiftyJSON

protocol BaseResponse {
    init(_ json: JSON)
}
