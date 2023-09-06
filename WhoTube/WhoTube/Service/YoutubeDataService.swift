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
    case getVideoInfo(videoId: String)
    case getComments(videoId: String, maxResults: Int, nextPageToken: String?)
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
        case .getVideoInfo:
            return "/videos"
        case .getComments:
            return "/commentThreads"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPlaylistItems,
             .getChannelInfo,
             .getVideoInfo,
             .getComments:
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
                      "key": AppConfig.apiKey.decrypt]
            if let nextPageToken = nextPageToken, !nextPageToken.isEmpty {
                params["pageToken"] = nextPageToken
            }
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getChannelInfo:
            var params : [String: Any] = [:]
            params = ["part": "snippet",
                      "id": AppConfig.channelId,
                      "key": AppConfig.apiKey.decrypt]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case let .getVideoInfo(videoId):
            var params : [String: Any] = [:]
            params = ["part": "snippet",
                      "id": videoId,
                      "key": AppConfig.apiKey.decrypt]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case let .getComments(videoId, maxResults, nextPageToken):
            var params : [String: Any] = [:]
            params = ["part": "snippet",
                      "videoId": videoId,
                      "maxResults": maxResults,
                      "key": AppConfig.apiKey.decrypt]
            
            if let nextPageToken = nextPageToken, !nextPageToken.isEmpty {
                params["pageToken"] = nextPageToken
            }
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
}

