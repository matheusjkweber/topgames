//
//  Endpoints.swift
//  Swish
//
//  Created by Matheus Weber on 24/08/16.
//  Copyright © 2016 Matheus Weber. All rights reserved.
//

import Foundation

struct Endpoints {
    
    enum URI : String {
        case Games = "/games"
    }
    static let clientId = "1234"
    fileprivate static let baseURL = "https://api.twitch.tv/kraken"
    
    static func urlEndpoint(_ uri:URI, id:Int? = nil) -> String {
        var url = "\(baseURL)\(uri.rawValue)"
        if let id = id {
            url += "/\(id)"
        }
        return url
    }
}
