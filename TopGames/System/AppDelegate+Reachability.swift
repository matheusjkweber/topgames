//
//  AppDelegate+Reachability.swift
//  TopGames
//
//  Created by Matheus Weber on 11/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit

extension AppDelegate {
    //MARK: Reachability
    func configureReachability() -> Void {
        
        //--- To check the reachability for the Internet Connection ---
        //--- register notification to handle network change ----
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkChange(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        
        //        reachability = Reachability.reachabilityForInternetConnection()
        reachability.startNotifier()
        
        if reachability.currentReachabilityStatus() == NotReachable {
            isReachable = false
        } else {
            isReachable = true
        }
    }
    
    @objc func handleNetworkChange(_ notification: Notification) -> Void {
        
        //--- set the isReachable flag to YES or NO when network changes ---
        
        let currentReachability: Reachability = notification.object as! Reachability
        let netStatus: NetworkStatus = currentReachability.currentReachabilityStatus();
        
        switch (netStatus) {
        case NotReachable:
            isReachable = false
        case ReachableViaWWAN, ReachableViaWiFi:
            isReachable = true
        default: break
        }
    }
}
