//
//  AppConfig.swift
//  WhoTube
//
//  Created by Raymondting on 2023/8/30.
//

import Foundation

public enum AppConfig {
    
    enum Keys {
        enum Plist {
            static let apiKey = "API_KEY"
            static let playListId = "PLAYLIST_ID"
            static let channelId = "CHANNEL_ID"
        }
    }

    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    static var apiKey: String = {
        guard let apiKey = AppConfig.infoDictionary[Keys.Plist.apiKey] as? String else {
            fatalError("apiKey not set in plist for this environment")
        }
        return apiKey
    }()
    
    static var playListId: String = {
        guard let playListId = AppConfig.infoDictionary[Keys.Plist.playListId] as? String else {
            fatalError("playListId not set in plist for this environment")
        }
        return playListId
    }()
    
    static var channelId: String = {
        guard let channelId = AppConfig.infoDictionary[Keys.Plist.channelId] as? String else {
            fatalError("playListId not set in plist for this environment")
        }
        return channelId
    }()
}
