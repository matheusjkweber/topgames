//
//  CollectionViewCellBuilder.swift
//  TopGames
//
//  Created by Matheus Weber on 10/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit

enum ReuseIdentifiers: String {
    case gameCollectionCell = "gameCollectionCell"
}

enum NibNames: String {
    case gameCollectionCell = "GameCollectionViewCell"
}

protocol CollectionViewCellBuilder {
    func registerCell(in collectionView: UICollectionView)
    func cellSize() -> CGSize
    func cellAt(indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell
    func reuseIdentifier() -> String
    func didSelectItemAt(indexPath: IndexPath)
}
