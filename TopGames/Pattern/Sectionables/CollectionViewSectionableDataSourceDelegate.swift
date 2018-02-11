//
//  CollectionViewSectionableDataSourceDelegate.swift
//  TopGames
//
//  Created by Matheus Weber on 10/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit

protocol CollectionSectionable {
    init(cellBuilders: [CollectionViewCellBuilder], in collectionView: UICollectionView)

    func numberOfRows() -> Int
    func cellSizeForIndexPath(_ indexPath: IndexPath,
                                in collectionView: UICollectionView) -> CGSize
    func cellForIndexPath(_ indexPath: IndexPath,
                          in collectionView: UICollectionView) -> UICollectionViewCell
}

class BaseSection: CollectionSectionable {
    let cellBuilders: [CollectionViewCellBuilder]
    
    required init(cellBuilders: [CollectionViewCellBuilder], in collectionView: UICollectionView) {
        self.cellBuilders = cellBuilders
        registerCells(in: collectionView)
    }
    
    private func registerCells(in collectionView: UICollectionView) {
        for builder in cellBuilders {
            builder.registerCell(in: collectionView)
        }
    }
    
    func numberOfRows() -> Int {
        return cellBuilders.count
    }
    
    func cellForIndexPath(_ indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell {
        let builder = cellBuilders[indexPath.row]
        return builder.cellAt(indexPath: indexPath, in: collectionView)
    }
    
    func cellSizeForIndexPath(_ indexPath: IndexPath, in collectionView: UICollectionView) -> CGSize {
        let builder = cellBuilders[indexPath.row]
        return builder.cellSize()
    }
    
    func didSelectItemAt(_ indexPath: IndexPath, in collectionView: UICollectionView) {
        
    }
}

class CollectionViewSectionableDataSourceDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Data Source
    let sections: [CollectionSectionable]
    
    init(sections: [CollectionSectionable]) {
        self.sections = sections
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionObj = sections[section]
        return sectionObj.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        return section.cellForIndexPath(indexPath, in: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = sections[indexPath.section]
        return section.cellSizeForIndexPath(indexPath, in: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section[indexPath.section]
        return section.didSelectItemAt(indexPath, in: collectionView)
    }
}
