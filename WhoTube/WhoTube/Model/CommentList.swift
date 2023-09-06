//
//  CommentList.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/5.
//

import SwiftyJSON

struct CommentThreadList: Codable {
    let kind: String
    let etag: String
    var nextPageToken: String
    let pageInfo: PageInfo
    let items: [CommentThread]
    
    init(_ json: JSON) {
        kind = json["kind"].stringValue
        etag = json["etag"].stringValue
        items = json["items"].arrayValue.map { CommentThread($0) }
        nextPageToken = json["nextPageToken"].stringValue
        pageInfo = PageInfo(json["pageInfo"])
    }
    
    mutating func updatePageToken(_ token: String) {
        nextPageToken = token
    }
}

struct CommentThread: Codable {
    let kind: String
    let etag: String
    let id: String
    let snippet: CommentThreadSnippet
    
    init(_ json: JSON) {
        kind = json["kind"].stringValue
        etag = json["etag"].stringValue
        id = json["id"].stringValue
        snippet = CommentThreadSnippet(json["snippet"])
    }
}

struct CommentThreadSnippet: Codable {
    let channelId: String
    let videoId: String
    let topLevelComment: TopLevelComment
    let canReply: Bool
    let totalReplyCount: Int
    let isPublic: Bool
    
    init(_ json: JSON) {
        channelId = json["channelId"].stringValue
        videoId = json["videoId"].stringValue
        topLevelComment = TopLevelComment(json["topLevelComment"])
        canReply = json["canReply"].boolValue
        totalReplyCount = json["totalReplyCount"].intValue
        isPublic = json["isPublic"].boolValue
    }
}

struct TopLevelComment: Codable {
    let kind: String
    let etag: String
    let id: String
    let snippet: CommentSnippet
    
    init(_ json: JSON) {
        kind = json["kind"].stringValue
        etag = json["etag"].stringValue
        id = json["id"].stringValue
        snippet = CommentSnippet(json["snippet"])
    }
}

struct CommentSnippet: Codable {
    let channelId: String
    let videoId: String
    let textDisplay: String
    let textOriginal: String
    let authorDisplayName: String
    let authorProfileImageUrl: String
    let authorChannelUrl: String
    let authorChannelId: AuthorChannelId
    let canRate: Bool
    let viewerRating: String
    let likeCount: Int
    let publishedAt: String
    let updatedAt: String
    
    init(_ json: JSON) {
        channelId = json["channelId"].stringValue
        videoId = json["videoId"].stringValue
        textDisplay = json["textDisplay"].stringValue
        textOriginal = json["textOriginal"].stringValue
        authorDisplayName = json["authorDisplayName"].stringValue
        authorProfileImageUrl = json["authorProfileImageUrl"].stringValue
        authorChannelUrl = json["authorChannelUrl"].stringValue
        authorChannelId = AuthorChannelId(json["authorChannelId"])
        canRate = json["canRate"].boolValue
        viewerRating = json["viewerRating"].stringValue
        likeCount = json["likeCount"].intValue
        publishedAt = json["publishedAt"].stringValue
        updatedAt = json["updatedAt"].stringValue
    }
}

struct AuthorChannelId: Codable {
    let value: String
    
    init(_ json: JSON) {
        value = json["value"].stringValue
    }
}

