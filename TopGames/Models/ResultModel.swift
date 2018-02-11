//
//  GameModel.swift
//  TopGames
//
//  Created by Matheus Weber on 10/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

struct ResultModel: Codable {
    var total: Int
    var top: [TopModel]
    
    private enum CodingKeys: String, CodingKey {
        case total = "_total"
        case top
    }
}

struct TopModel: Codable {
    var channels: Int
    var viewers: Int
    var game: GameModel
}

struct ImageModel: Codable {
    var large: String
    var medium: String
    var small: String
    var template: String
}

struct GameModel: Codable {
    var id: Int
    var name: String
    var popularity: Int
    var giantbombId: Int
    var locale: String
    var localizedName: String
    var box: ImageModel
    var logo: ImageModel
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case popularity
        case giantbombId = "giantbomb_id"
        case locale
        case localizedName = "localized_name"
        case box
        case logo
    }
}
