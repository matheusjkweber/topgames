//
//  GameCollectionViewCell.swift
//  TopGames
//
//  Created by Matheus Weber on 10/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit

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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
    }
}

extension GameCollectionViewCell {
    func setup(gameModel: GameModel) {
        gameNameLabel.text = gameModel.title
        
        setLayout()
    }
    
    fileprivate func setLayout() {
        gameImageView.clipsToBounds = true
        gameImageView.layer.cornerRadius = 50
        
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1
    }
}

