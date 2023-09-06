//
//  VideoList.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/5.
//

import SwiftyJSON

struct VideoList: Codable {
    let kind: String
    let etag: String
    let items: [VideoItem]
    let pageInfo: PageInfo
    
    init(_ json: JSON) {
        kind = json["kind"].stringValue
        etag = json["etag"].stringValue
        items = json["items"].arrayValue.map { VideoItem($0) }
        pageInfo = PageInfo(json["pageInfo"])
    }
}

struct VideoItem: Codable {
    let kind: String
    let etag: String
    let id: String
    let snippet: Snippet
    
    init(_ json: JSON) {
        kind = json["kind"].stringValue
        etag = json["etag"].stringValue
        id = json["id"].stringValue
        snippet = Snippet(json["snippet"])
    }
}

struct Snippet: Codable {
    let publishedAt: String
    let channelId: String
    let title: String
    let description: String
    let thumbnails: Thumbnails
    let channelTitle: String
    let tags: [String]
    let categoryId: String
    let liveBroadcastContent: String
    let localized: Localized
    let defaultAudioLanguage: String
    
    init(_ json: JSON) {
        publishedAt = json["publishedAt"].stringValue
        channelId = json["channelId"].stringValue
        title = json["title"].stringValue
        description = json["description"].stringValue
        thumbnails = Thumbnails(json["thumbnails"])
        channelTitle = json["channelTitle"].stringValue
        tags = json["tags"].arrayValue.map { $0.stringValue }
        categoryId = json["categoryId"].stringValue
        liveBroadcastContent = json["liveBroadcastContent"].stringValue
        localized = Localized(json["localized"])
        defaultAudioLanguage = json["defaultAudioLanguage"].stringValue
    }
}

struct Thumbnails: Codable {
    let defaultSize: Thumbnail
    let medium: Thumbnail
    let high: Thumbnail
    let standard: Thumbnail
    
    init(_ json: JSON) {
        defaultSize = Thumbnail(json["defaultSize"])
        medium = Thumbnail(json["medium"])
        high = Thumbnail(json["high"])
        standard = Thumbnail(json["standard"])
    }
    
    enum CodingKeys: String, CodingKey {
        case defaultSize = "default"
        case medium, high, standard
    }
}

struct Thumbnail: Codable {
    let url: String
    let width: Int
    let height: Int
    
    init(_ json: JSON) {
        url = json["url"].stringValue
        width = json["width"].intValue
        height = json["height"].intValue
    }
}

struct Localized: Codable {
    let title: String
    let description: String
    
    init(_ json: JSON) {
        title = json["title"].stringValue
        description = json["description"].stringValue
    }
}
