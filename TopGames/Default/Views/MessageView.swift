//
//  MessageView.swift
//  TopGames
//
//  Created by Matheus Weber on 11/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit

enum MessageType {
    case OfflineWithData
    case OfflineWithoutData
    case OnlineAgain
}

class MessageView: UIView {
    static var isShowingMessage = false
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    
    var type:MessageType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    init(frame: CGRect, text: String) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(frame: CGRect, text: String, type: MessageType) {
        textLabel.text = text
        self.frame = frame
        self.type = type
        self.changeLayout()
        self.openingAnimation()
    }
    
    func changeLayout() {
        if let type = type {
            switch(type) {
            case .OfflineWithData:
                backgroundColor = UIColor.yellow
            case .OfflineWithoutData:
                backgroundColor = UIColor.red
            case .OnlineAgain:
                backgroundColor = UIColor.green
            }
            
        }
    }
    
    func openingAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
            self.frame.size.height = 70
        }, completion: { finished in
            UIView.animate(withDuration: 1.0, animations: {
                self.textLabel.alpha = 1
                self.closeButton.alpha = 1
            })
        })
    }
    
    func closingAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
            self.textLabel.alpha = 0
            self.closeButton.alpha = 0
        }, completion: { finished in
            UIView.animate(withDuration: 0.3, animations: {
                self.frame.size.height = 0
            }, completion: { finished in
                self.removeFromSuperview()
            })
        })
    }
    
    @IBAction func closeButtonDidTapped(_ sender: Any) {
        MessageView.isShowingMessage = false
        closingAnimation()
    }
    
    static func callMessageView(in vc: UIViewController, text: String, type: MessageType) {
        if !isShowingMessage {
            isShowingMessage = true
            let screenSize: CGRect = UIScreen.main.bounds
            let frame = CGRect(x: 0, y: 60, width: screenSize.width, height: 0)
            let nib = UINib(nibName: "MessageView", bundle: nil)
            let messageView = nib.instantiate(withOwner: self, options: nil)[0] as! MessageView
            messageView.setup(frame: frame, text: text, type: type)
            vc.view.addSubview(messageView)
        }
    }
}
