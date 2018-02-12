//
//  GameModel.swift
//  TopGames
//
//  Created by Matheus Weber on 10/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit
import AlamofireImage

enum ImageType {
    case box
    case logo
}

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
    
    init(top: Top) {
        channels = top.value(forKey: "channels") as? Int ?? 0
        viewers = top.value(forKey: "viewers") as? Int ?? 0
        game = GameModel(game: top.value(forKey: "game") as? Game ?? Game())
    }
}

struct ImageModel: Codable {
    var large: String
    var medium: String
    var small: String
    var template: String
    
    init(image: Image) {
        large = image.value(forKey: "large") as? String ?? ""
        medium = image.value(forKey: "medium") as? String ?? ""
        small = image.value(forKey: "small") as? String ?? ""
        template = image.value(forKey: "template") as? String ?? ""
    }
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
    
    init(game: Game) {
        id = game.value(forKey: "id") as? Int ?? 0
        name = game.value(forKey: "name") as? String ?? ""
        popularity = game.value(forKey: "popularity") as? Int ?? 0
        giantbombId = game.value(forKey: "giantbombId") as? Int ?? 0
        locale = game.value(forKey: "locale") as? String ?? ""
        localizedName = game.value(forKey: "localizedName") as? String ?? ""
        box = ImageModel(image: game.value(forKey: "box") as? Image ?? Image())
        logo = ImageModel(image: game.value(forKey: "logo") as? Image ?? Image())
    }
    
    func getImage(type: ImageType, completion: @escaping (UIImage) -> Void) {
        let cache = ImageCache()
        
        var name = localizedName
        var imagePath = logo.large
        
        if type == .box {
            name = "\(localizedName)_box"
            imagePath = box.large
        }
        
        if let image = cache.getSavedImage(named: name) {
            completion(image)
        } else if let url = URL(string: imagePath){
            UIImageView().af_setImage(withURL: url, placeholderImage: UIImage(named: "no-image"), imageTransition: .crossDissolve(TimeInterval(0.5)), completion:{ response in
                if let image = response.result.value{
                    cache.saveImageToDisk(image: image, and: name)
                    completion(image)
                }
            })
        }
    }
}
