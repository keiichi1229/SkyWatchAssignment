//
//  AppCache.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/6.
//

import Foundation

enum CacheType: String {
    case playItemList
}

class AppCache {
    static let shared = AppCache()

    private let userDefaults = UserDefaults.standard

    func save<T: Codable>(data: T, forType type: CacheType) {
        let key = type.rawValue
        do {
            let encodedData = try JSONEncoder().encode(data)
            userDefaults.set(encodedData, forKey: key)
        } catch {
            print("Error saving data for type \(type): \(error)")
        }
    }

    func retrieve<T: Codable>(forType type: CacheType) -> T? {
        let key = type.rawValue
        if let data = userDefaults.data(forKey: key) {
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            } catch {
                print("Error retrieving data for type \(type): \(error)")
            }
        }
        return nil
    }

    func update<T: Codable>(data: T, forType type: CacheType) {
        save(data: data, forType: type)
    }

    func clear(forType type: CacheType) {
        let key = type.rawValue
        userDefaults.removeObject(forKey: key)
    }
}

