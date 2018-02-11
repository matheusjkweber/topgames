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
        gameNameLabel.text = topModel.game.localizedName
        
        setLayout()
        getImageFromServer(from: topModel.game.logo.medium, with: topModel.game.localizedName)
    }
    
    fileprivate func setLayout() {
        gameImageView.clipsToBounds = true
        gameImageView.layer.cornerRadius = 50
        
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1
    }
    
    func getImageFromServer(from imagePath: String, with name: String) {
        let cache = ImageCache()
        if let image = cache.getSavedImage(named: name) {
            UIView.transition(with: gameImageView,
                                      duration: 0.5,
                                      options: UIViewAnimationOptions.transitionCrossDissolve,
                                      animations: { self.gameImageView.image = image },
                                      completion: nil)
        } else if let url = URL(string: imagePath){
            gameImageView.af_setImage(withURL: url, placeholderImage: UIImage(named: "no-image"), imageTransition: .crossDissolve(TimeInterval(0.5)), completion:{ response in
                if let image = response.result.value{
                    cache.saveImageToDisk(image: image, and: name)
                }
            })
        }
    }
}

