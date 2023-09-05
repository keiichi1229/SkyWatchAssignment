//
//  YoutubeDataService.swift
//  WhoTube
//
//  Created by Raymondting on 2023/8/31.
//

import Foundation
import Moya

enum YoutubeDataService {
    case getPlaylistItems(maxResults: Int, nextPageToken: String?)
    case getChannelInfo
}

extension YoutubeDataService: TargetType {
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL {
            return URL(string: "https://www.googleapis.com/youtube/v3")!
    }
    
    var path: String {
        switch self {
        case .getPlaylistItems:
            return "/playlistItems"
        case .getChannelInfo:
            return "/channels"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPlaylistItems,
             .getChannelInfo:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .getPlaylistItems(maxResults, nextPageToken):
            var params : [String: Any] = [:]
            params = ["maxResults": maxResults,
                      "part": "snippet",
                      "playlistId": AppConfig.playListId,
                      "key": AppConfig.apiKey]
            if let nextPageToken = nextPageToken {
                params["pageToken"] = nextPageToken
            }
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getChannelInfo:
            var params : [String: Any] = [:]
            params = ["part": "snippet",
                      "id": AppConfig.channelId,
                      "key": AppConfig.apiKey]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
}

