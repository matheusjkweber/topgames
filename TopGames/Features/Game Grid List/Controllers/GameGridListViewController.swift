//
//  GameGridListViewController.swift
//  TopGames
//
//  Created by Matheus Weber on 10/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit
import SwiftSpinner

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
    var topList: [TopModel] {
        didSet { setupDatasource() }
    }
    
    init(topList: [TopModel]) {
        self.topList = topList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.topList = [TopModel]()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatasource()
        getGames()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getGames() {
        if isReachable {
            SwiftSpinner.show("Loading games...")
            RouterService.sharedInstance.FetchTopGames(with: 10, and: 10, { (result) in
                switch(result) {
                case .success(let top):
                    if let top = top as? [TopModel] {
                        self.topList = top
                    }
                    break
                case .error(let error):
                    print(error)
                }
                SwiftSpinner.hide()
            })
        } else {
            
        }
    }
    
    func setupDatasource() {
        datasource = CollectionViewSectionableDataSourceDelegate(sections: sections())
        collectionView.delegate = datasource
        collectionView.dataSource = datasource
        collectionView.reloadData()
    }
    
    func gamesInfoSections() -> [CollectionSectionable] {
        return [GamesFactory(collectionView: collectionView, with: self, and: topList).build()]
    }
    
    func callMessageView(text: String, type: MessageType) {
        MessageView.callMessageView(in: self, text: text, type: type)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath {
            if let detailsViewController = segue.destination as? GameDetailViewController {
                detailsViewController.topModel = topList[indexPath.row]
            }
        }
    }
}

extension GameGridListViewController: GameCollectionViewCellBuilderDelegate {
    func didSelectItemAt(_ indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueToGameDetail", sender: indexPath)
    }
}
