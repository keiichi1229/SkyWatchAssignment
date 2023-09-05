//
//  PlayItemList.swift
//  WhoTube
//
//  Created by Raymondting on 2023/8/31.
//

import SwiftyJSON

struct PlayItemList: Codable {
    var kind: String
    var etag: String
    var nextPageToken: String
    var items: [PlayItem] = []
    var pageInfo: PageInfo
    
    init(_ json: JSON) {
        kind = json["kind"].stringValue
        etag = json["etag"].stringValue
        nextPageToken = json["nextPageToken"].stringValue
        pageInfo = PageInfo(json["pageInfo"])
        items = json["items"].arrayValue.map { PlayItem($0) }
    }
    
    mutating func updateNextPageToken(token: String) {
        nextPageToken = token
    }
}

struct PlayItem: Codable {
    var kind: String
    var etag: String
    var id: String
    var snippet: PlayItemSnippet
    var ownerThumbnails: ChannelItemThumbnails?
    
    init(_ json: JSON) {
        kind = json["kind"].stringValue
        etag = json["etag"].stringValue
        id = json["id"].stringValue
        snippet = PlayItemSnippet(json["snippet"])
    }
    
    mutating func updateOwnerThumbnail(_ channelThumbnail: ChannelItemThumbnails?) {
        guard let channelThumbnail = channelThumbnail else { return }
        ownerThumbnails = channelThumbnail
    }
}

struct PlayItemSnippet: Codable {
    var publishedAt: String
    var channelId: String
    var title: String
    var description: String
    var thumbnails: PlayItemThumbnails
    var channelTitle: String
    var playlistId: String
    var position: Int
    var resourceId: ResourceId
    var videoOwnerChannelTitle: String
    var videoOwnerChannelId: String
    
    init(_ json: JSON) {
        publishedAt = json["publishedAt"].stringValue
        channelId = json["channelId"].stringValue
        title = json["title"].stringValue
        description = json["description"].stringValue
        thumbnails = PlayItemThumbnails(json["thumbnails"])
        channelTitle = json["channelTitle"].stringValue
        playlistId = json["playlistId"].stringValue
        position = json["position"].intValue
        resourceId = ResourceId(json["resourceId"])
        videoOwnerChannelTitle = json["videoOwnerChannelTitle"].stringValue
        videoOwnerChannelId = json["videoOwnerChannelId"].stringValue
    }
}

struct PlayItemThumbnails: Codable {
    var defaultSetting: InfoData
    var medium: InfoData
    var high: InfoData
    var standard: InfoData
    var maxres: InfoData
    
    init(_ json: JSON) {
        defaultSetting = InfoData(json["default"])
        medium = InfoData(json["medium"])
        high = InfoData(json["high"])
        standard = InfoData(json["standard"])
        maxres = InfoData(json["maxres"])
    }
}

struct InfoData: Codable {
    var url: String
    var width: Double
    var height: Double
    
    init(_ json: JSON) {
        url = json["url"].stringValue
        width = json["width"].doubleValue
        height = json["height"].doubleValue
    }
}

struct ResourceId: Codable {
    var kind: String
    var videoId: String
    
    init(_ json: JSON) {
        kind = json["kind"].stringValue
        videoId = json["videoId"].stringValue
    }
}

struct PageInfo: Codable {
    var totalResults: Int
    var resultsPerPage: Int
    
    init(_ json: JSON) {
        totalResults = json["totalResults"].intValue
        resultsPerPage = json["resultsPerPage"].intValue
    }
}
