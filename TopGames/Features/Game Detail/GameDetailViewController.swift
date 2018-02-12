//
//  GameDetailViewController.swift
//  TopGames
//
//  Created by Matheus Weber on 10/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit
import SwiftSpinner

class GameDetailViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var viewersLabel: UILabel!
    @IBOutlet weak var boxImageView: UIImageView!
    
    var topModel: TopModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        title = topModel?.game.localizedName
    }
    
    func loadData() {
        if let topModel = topModel {
            channelLabel.text = "\(topModel.channels) canais"
            viewersLabel.text = "\(topModel.viewers) visualizações"
            
            topModel.game.getImage(type: .logo) { (image) in
                UIView.transition(with: self.logoImageView,
                                  duration: 0.5,
                                  options: UIViewAnimationOptions.transitionCrossDissolve,
                                  animations: { self.logoImageView.image = image },
                                  completion: nil)
                if isReachable {
                    topModel.game.getImage(type: .box) { (image) in
                        UIView.transition(with: self.boxImageView,
                                          duration: 0.5,
                                          options: UIViewAnimationOptions.transitionCrossDissolve,
                                          animations: { self.boxImageView.image = image },
                                          completion: nil)
                        SwiftSpinner.hide()
                    }
                } else {
                    SwiftSpinner.hide()
                }
                
            }
            
        } else {
            channelLabel.text = ""
            viewersLabel.text = ""
        }
        
        SwiftSpinner.show("Loading...")
    }
}
