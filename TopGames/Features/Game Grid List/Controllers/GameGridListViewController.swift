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

enum RequestType {
    case offlineWithData
    case offlineWithoutData
    case onlineAgain
}

class GameGridListViewController: UIViewController, GameListInfoProtocol {
    var datasource: CollectionViewSectionableDataSourceDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    var offlineSometime: Bool = false
    
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
        setupReachability()
        setupDatasource()
        getGames()
        CoreDataManager.shared.retrieveGames()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getGames() {
        if isReachable {
            if offlineSometime {
                callMessageView(text: "Agora que você está de volta online, estamos atualizando a lista de jogos com o servidor!", type: .onlineAgain)
            }
            
            SwiftSpinner.show("Loading games...")
            RouterService.sharedInstance.FetchTopGames(with: 10, and: 10, { (result) in
                switch(result) {
                case .success(let tops):
                    if let tops = tops as? [TopModel] {
                        for top in tops {
                            CoreDataManager.shared.addGame(topModel: top)
                        }
                        self.topList = CoreDataManager.shared.retrieveGames()
                    }
                    break
                case .error(let error):
                    print(error)
                }
                SwiftSpinner.hide()
            })
        } else {
            offlineSometime = true
            topList = CoreDataManager.shared.retrieveGames()
            
            if topList.isEmpty {
                callMessageView(text: "Por favor, conecte-se com a internet ao menos uma vez para podermos nos conectar com o servidor.", type: .offlineWithoutData)
            } else {
                callMessageView(text: "Você está offline, mas sem problemas já temos alguns jogos salvos no celular.", type: .offlineWithData)
            }
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
    
    func callMessageView(text: String, type: RequestType) {
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

//MARK - Deal with internet.
extension GameGridListViewController {
    func setupReachability() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkChange(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)
    }
    @objc func handleNetworkChange(_ notification: Notification){
        getGames()
    }
}
