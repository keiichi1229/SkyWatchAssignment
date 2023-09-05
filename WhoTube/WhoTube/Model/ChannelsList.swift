//
//  ChannelsList.swift
//  WhoTube
//
//  Created by Raymondting on 2023/8/31.
//

import SwiftyJSON

struct ChannelsList: Codable {
    var kind: String
    var etag: String
    var items: [ChannelItem] = []
    var pageInfo: PageInfo
    
    init(_ json: JSON) {
        kind = json["kind"].stringValue
        etag = json["etag"].stringValue
        items = json["items"].arrayValue.map { ChannelItem($0) }
        pageInfo = PageInfo(json["pageInfo"])
    }
}

struct ChannelItem: Codable {
    var kind: String
    var etag: String
    var id: String
    var snippet: ChannelItemSnippet
    
    init(_ json: JSON) {
        kind = json["kind"].stringValue
        etag = json["etag"].stringValue
        id = json["id"].stringValue
        snippet = ChannelItemSnippet(json["snippet"])
    }
}

struct ChannelItemSnippet: Codable {
    var title: String
    var description: String
    var publishedAt: String
    var customUrl: String
    var thumbnails: ChannelItemThumbnails
    var localized: ChannelLocalized
    
    init(_ json: JSON) {
        publishedAt = json["publishedAt"].stringValue
        title = json["title"].stringValue
        description = json["description"].stringValue
        thumbnails = ChannelItemThumbnails(json["thumbnails"])
        customUrl = json["customUrl"].stringValue
        localized = ChannelLocalized(json["localized"])
    }
}

struct ChannelItemThumbnails: Codable {
    var defaultSetting: InfoData
    var medium: InfoData
    var high: InfoData
    var standard: InfoData
    
    init(_ json: JSON) {
        defaultSetting = InfoData(json["default"])
        medium = InfoData(json["medium"])
        high = InfoData(json["high"])
        standard = InfoData(json["standard"])
    }
}

struct ChannelLocalized: Codable {
    var title: String
    var description: String
    
    init(_ json: JSON) {
        title = json["title"].stringValue
        description = json["description"].stringValue
    }
}
