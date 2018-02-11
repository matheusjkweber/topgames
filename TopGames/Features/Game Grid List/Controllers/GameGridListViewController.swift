//
//  GameGridListViewController.swift
//  TopGames
//
//  Created by Matheus Weber on 10/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit

protocol GameListInfoProtocol {
    func sections() -> [CollectionSectionable]
    func gamesInfoSections() -> [CollectionSectionable]
    
   // func paymentInfoSectionState() -> PaymentInfoStateProtocol?
}

extension GameListInfoProtocol {
    func sections() -> [CollectionSectionable] {
        var sections: [CollectionSectionable] = []
        sections.append(contentsOf: gamesInfoSections())
        return sections
    }
}

class GameGridListViewController: UIViewController, GameListInfoProtocol {
    var datasource: CollectionViewSectionableDataSourceDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    var gamesList: [GameModel]
    
    init(gamesList: [GameModel]) {
        self.gamesList = gamesList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.gamesList = [GameModel]()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mockModels()
        setupDatasource()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupDatasource() {
        datasource = CollectionViewSectionableDataSourceDelegate(sections: sections())
        collectionView.delegate = datasource
        collectionView.dataSource = datasource
        collectionView.reloadData()
    }
    
    func gamesInfoSections() -> [CollectionSectionable] {
        return [GamesFactory(collectionView: collectionView, gamesList: gamesList).build()]
    }
    
    func mockModels() {
        self.gamesList = [GameModel(imageUrl: "", title: "Test"),  GameModel(imageUrl: "", title: "Test1"),  GameModel(imageUrl: "", title: "Test2"),  GameModel(imageUrl: "", title: "Test3"),  GameModel(imageUrl: "", title: "Test4"),  GameModel(imageUrl: "", title: "Test5"),  GameModel(imageUrl: "", title: "Test6"),  GameModel(imageUrl: "", title: "Test7")]
    }
}
