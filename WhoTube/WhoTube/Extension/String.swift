//
//  String.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/4.
//
import Foundation
import CryptoSwift

extension String {
    var yyyyMMddhhmmss: String {
        let inputFormatter = DateFormatter()
        inputFormatter.calendar = Calendar(identifier: .iso8601)
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale.current
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = inputFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        } else {
            return self
        }
    }
    
    var decrypt: String {
        let key: [UInt8] = Array("whotEncryptionKeyyoEncryptionKey".utf8)  // 32 bytes
        let iv: [UInt8] = Array("InitializationV1".utf8)  // 16 bytes
        do {
            guard let data = Data(hex: self) else {
                print("Error: Could not decode hex")
                return ""
            }
            
            let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)
            let decrypted = try aes.decrypt([UInt8](data))
            let decryptedText = String(bytes: decrypted, encoding: .utf8) ?? ""
            return decryptedText
        } catch {
            print("Error: \(error)")
            return ""
        }
    }
}

extension Data {
    init?(hex: String) {
        let length = hex.count / 2
        var data = Data(capacity: length)
        
        var index = hex.startIndex
        for _ in 0..<length {
            let nextIndex = hex.index(index, offsetBy: 2)
            if let byte = UInt8(hex[index..<nextIndex], radix: 16) {
                data.append(byte)
            } else {
                return nil
            }
            index = nextIndex
        }
        
        self = data
    }
}






