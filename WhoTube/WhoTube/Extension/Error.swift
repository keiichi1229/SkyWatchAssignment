//
//  Error.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/6.
//

import Foundation

extension Error {
    var msg: String {
        return (self as? LocalizedError)?.errorDescription ?? localizedDescription
    }
}
