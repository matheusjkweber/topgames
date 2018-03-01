//
//  CollectionViewSectionableDataSourceDelegate.swift
//  TopGames
//
//  Created by Matheus Weber on 10/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit

protocol CollectionSectionable {
    init(cellBuilder: CollectionViewCellBuilder, in collectionView: UICollectionView)

    func numberOfRows() -> Int
    func cellSizeForIndexPath(_ indexPath: IndexPath,
                                in collectionView: UICollectionView) -> CGSize
    func cellForIndexPath(_ indexPath: IndexPath,
                          in collectionView: UICollectionView) -> UICollectionViewCell
    func didSelectItemAt(_ indexPath: IndexPath, in collectionView: UICollectionView)
}

class BaseSection: CollectionSectionable {
    let cellBuilder: CollectionViewCellBuilder
    
    required init(cellBuilder: CollectionViewCellBuilder, in collectionView: UICollectionView) {
        self.cellBuilder = cellBuilder
        registerCells(in: collectionView)
    }
    
    private func registerCells(in collectionView: UICollectionView) {
        cellBuilder.registerCell(in: collectionView)
    }
    
    func numberOfRows() -> Int {
        return cellBuilder.numberOfCells()
    }
    
    func cellForIndexPath(_ indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell {
        return cellBuilder.cellAt(indexPath: indexPath, in: collectionView)
    }
    
    func cellSizeForIndexPath(_ indexPath: IndexPath, in collectionView: UICollectionView) -> CGSize {
        return cellBuilder.cellSize()
    }
    
    func didSelectItemAt(_ indexPath: IndexPath, in collectionView: UICollectionView) {
        cellBuilder.didSelectItemAt(indexPath: indexPath)
    }
    
    func numberOfCells() -> Int{
        return cellBuilder.numberOfCells()
    }
}

protocol CollectionViewSectionableDelegate: class {
    func willDisplay()
}

class CollectionViewSectionableDataSourceDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Data Source
    let sections: [CollectionSectionable]
    weak var delegate: CollectionViewSectionableDelegate?

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
        let section = sections[indexPath.section]
        return section.didSelectItemAt(indexPath, in: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == sections[indexPath.section].numberOfRows() - 1 {
            delegate?.willDisplay()
        }
    }
}
