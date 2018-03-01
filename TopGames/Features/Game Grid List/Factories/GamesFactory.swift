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
    let gamesList: [TopModel]
    
    init(collectionView: UICollectionView, with handler: GameCollectionViewCellBuilderDelegate, and gamesList: [TopModel]) {
        self.collectionView = collectionView
        self.gamesList = gamesList
        self.handler = handler
    }
    
    func build() -> CollectionSectionable {
        let builder = GameCollectionViewCellBuilder(topModels: gamesList)
        builder.delegate = handler
        
        return BaseSection(cellBuilder: builder, in: collectionView)
    }
}

