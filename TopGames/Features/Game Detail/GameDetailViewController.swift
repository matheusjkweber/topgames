//
//  GameDetailViewController.swift
//  TopGames
//
//  Created by Matheus Weber on 10/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController {
    var gameModel: GameModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        title = gameModel?.title
    }
}
