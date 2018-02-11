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
    let handler: GameCollectionViewCellBuilderDelegate
    let collectionView: UICollectionView
    let gamesList: [GameModel]
    
    init(collectionView: UICollectionView, with handler: GameCollectionViewCellBuilderDelegate, and gamesList: [GameModel]) {
        self.collectionView = collectionView
        self.gamesList = gamesList
        self.handler = handler
    }
    
    func build() -> CollectionSectionable {
        var builders = [CollectionViewCellBuilder]()
        
        for game in gamesList {
            let builder = GameCollectionViewCellBuilder(gameModel: game)
            builder.delegate = handler
            builders.append(builder)
        }
        
        return BaseSection(cellBuilders: builders, in: collectionView)
    }
}

