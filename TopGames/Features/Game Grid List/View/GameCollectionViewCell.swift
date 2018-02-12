//
//  GameCollectionViewCell.swift
//  TopGames
//
//  Created by Matheus Weber on 10/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit
import AlamofireImage

class GameCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension GameCollectionViewCell {
    func setup(topModel: TopModel) {
        gameNameLabel.text = topModel.game.name
        
        setLayout()
        
        loadImage(topModel: topModel)
    }
    
    fileprivate func setLayout() {
        gameImageView.clipsToBounds = true
        gameImageView.layer.cornerRadius = 50
        
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1
    }
    
    func loadImage(topModel: TopModel) {
        topModel.game.getImage(type: .logo) { (image) in
            UIView.transition(with: self.gameImageView,
                              duration: 0.5,
                              options: UIViewAnimationOptions.transitionCrossDissolve,
                              animations: { self.gameImageView.image = image },
                              completion: nil)
        }
    }
}

