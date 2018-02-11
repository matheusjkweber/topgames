//
//  GameCollectionViewCellBuilder.swift
//  TopGames
//
//  Created by Matheus Weber on 10/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit

final class GameCollectionViewCellBuilder: CollectionViewCellBuilder {
    var gameModel: GameModel
    
    init(gameModel: GameModel) {
        self.gameModel = gameModel
    }
    
    func registerCell(in collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: NibNames.gameCollectionCell.rawValue, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier())
    }
    
    func cellSize() -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    func cellAt(indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier(), for: indexPath) as? GameCollectionViewCell else {
            fatalError("Must be provide a GameCollectionViewCell")
        }
        
        cell.setup(
            gameModel: gameModel
        )
        
        return cell
    }
    
    func reuseIdentifier() -> String {
        return ReuseIdentifiers.gameCollectionCell.rawValue
    }
}
