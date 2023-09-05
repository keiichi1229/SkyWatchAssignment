//
//  String.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/4.
//
import Foundation

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
}
