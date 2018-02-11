//
//  GameCollectionViewCellBuilder.swift
//  TopGames
//
//  Created by Matheus Weber on 10/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit

protocol GameCollectionViewCellBuilderDelegate: class {
    func didSelectItemAt(_ indexPath: IndexPath)
}

final class GameCollectionViewCellBuilder: CollectionViewCellBuilder {
    var gameModel: GameModel
    weak var delegate: GameCollectionViewCellBuilderDelegate?
    
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
    
    func didSelectItemAt(indexPath: IndexPath) {
        delegate?.didSelectItemAt(indexPath)
    }
}
