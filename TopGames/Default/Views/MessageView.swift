//
//  MessageView.swift
//  TopGames
//
//  Created by Matheus Weber on 11/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit

class MessageView: UIView {
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    
    var type:RequestType?

    static var activeMessageView: MessageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    init(frame: CGRect, text: String) {
        super.init(frame: frame)
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(frame: CGRect, text: String, type: RequestType) {
        textLabel.text = text
        self.frame = frame
        self.type = type
        self.changeLayout()
        self.openingAnimation()
    }
    
    func changeLayout() {
        if let type = type {
            switch(type) {
            case .offlineWithData:
                backgroundColor = UIColor.yellow
            case .offlineWithoutData:
                backgroundColor = UIColor.red
            case .onlineAgain:
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.closingAnimation(completion: {})
        })
    }
    
    func closingAnimation(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
            self.textLabel.alpha = 0
            self.closeButton.alpha = 0
        }, completion: { finished in
            UIView.animate(withDuration: 0.3, animations: {
                self.frame.size.height = 0
            }, completion: { finished in
                self.removeFromSuperview()
                completion()
            })
        })
    }
    
    @IBAction func closeButtonDidTapped(_ sender: Any) {
        closingAnimation(completion: {})
    }
    
    static func callMessageView(in vc: UIViewController, text: String, type: RequestType) {
        let screenSize: CGRect = UIScreen.main.bounds
        let frame = CGRect(x: 0, y: 60, width: screenSize.width, height: 0)
        let nib = UINib(nibName: "MessageView", bundle: nil)
        
        if var messageView = activeMessageView {
            messageView.closingAnimation(completion: {
                messageView = nib.instantiate(withOwner: self, options: nil)[0] as! MessageView
                messageView.setup(frame: frame, text: text, type: type)
                activeMessageView = messageView
                vc.view.addSubview(messageView)
            })
        } else {
            let messageView = nib.instantiate(withOwner: self, options: nil)[0] as! MessageView
            messageView.setup(frame: frame, text: text, type: type)
            activeMessageView = messageView
            vc.view.addSubview(messageView)
        }
    }
}
