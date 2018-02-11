//
//  GamesFactory.swift
//  TopGames
//
//  Created by Matheus Weber on 10/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import Foundation
import UIKit

class GamesFactory {
    
    let collectionView: UICollectionView
    let gamesList: [GameModel]
    
    init(collectionView: UICollectionView, gamesList: [GameModel]) {
        self.collectionView = collectionView
        self.gamesList = gamesList
    }
    
    func build() -> CollectionSectionable {
        var builders = [CollectionViewCellBuilder]()
        
        for game in gamesList {
            builders.append(GameCollectionViewCellBuilder(gameModel: game))
        }
        
        return BaseSection(cellBuilders: builders, in: collectionView)
    }
}

