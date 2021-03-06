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

//MARK: Init viewcontroller
class GameGridListViewController: UIViewController, GameListInfoProtocol {
    var datasource: CollectionViewSectionableDataSourceDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    
    var offlineSometime: Bool = false
    var page = 1
    var elementsPerPage = 10
    
    private let refreshControl = UIRefreshControl()

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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupDatasource() {
        datasource = CollectionViewSectionableDataSourceDelegate(sections: sections())
        datasource?.delegate = self
        collectionView.delegate = datasource
        collectionView.dataSource = datasource
        collectionView.reloadData()
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        collectionView.addSubview(refreshControl)
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

//MARK: Requests
extension GameGridListViewController {
    func getGames() {
        if isReachable {
            getGamesWhenOnline()
        } else {
            getGamesWhenOffline()
        }
    }
    
    func getGamesWhenOnline() {
        let limit = elementsPerPage
        let offset = (page - 1) * elementsPerPage
        
        if offlineSometime {
            callMessageView(text: "Agora que você está de volta online, estamos atualizando a lista de jogos com o servidor!", type: .onlineAgain)
        }
        
        SwiftSpinner.show("Loading games...")
        RouterService.sharedInstance.FetchTopGames(with: limit, and: offset, { (result) in
            switch(result) {
            case .success(let tops):
                if let tops = tops as? [TopModel] {
                    for top in tops {
                        CoreDataManager.shared.addGame(topModel: top)
                    }
                    if self.page > 1 {
                        self.topList.append(contentsOf: CoreDataManager.shared.retrieveGames(limit: limit, offset: offset))
                    } else {
                        self.topList = CoreDataManager.shared.retrieveGames(limit: limit, offset: offset)
                    }
                    self.stopRefresher()
                }
                break
            case .error(let error):
                print(error)
            }
            SwiftSpinner.hide()
        })
    }
    
    func getGamesWhenOffline() {
        let limit = elementsPerPage
        let offset = (page - 1) * elementsPerPage
        
        offlineSometime = true
        
        if page > 1 {
            self.topList.append(contentsOf: CoreDataManager.shared.retrieveGames(limit: limit, offset: offset))
        } else {
            self.topList = CoreDataManager.shared.retrieveGames(limit: limit, offset: offset)
        }
        
        if topList.isEmpty {
            callMessageView(text: "Por favor, conecte-se com a internet ao menos uma vez para podermos nos conectar com o servidor.", type: .offlineWithoutData)
        } else {
            callMessageView(text: "Você está offline, mas sem problemas já temos alguns jogos salvos no celular.", type: .offlineWithData)
        }
    }
}

//MAKR: GameCollectionView Delegate
extension GameGridListViewController: GameCollectionViewCellBuilderDelegate {
    func didSelectItemAt(_ indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueToGameDetail", sender: indexPath)
    }
}

//MARK: Reachability
extension GameGridListViewController {
    func setupReachability() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkChange(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)
    }
    @objc func handleNetworkChange(_ notification: Notification){
        getGames()
    }
}

//MARK: RefreshControl
extension GameGridListViewController {
    @objc func refresh(_ sender: Any) {
        // Fetch Weather Data
        page = 1
        getGames()
    }
    
    func stopRefresher(){
        refreshControl.endRefreshing()
    }
}

//MARK: CollectionViewSectionable Delegate
extension GameGridListViewController: CollectionViewSectionableDelegate {
    func willDisplay() {
        if isReachable {
            page = page + 1
            getGames()
        }
    }
}
