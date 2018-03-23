//
//  RecheabilityManager.swift
//  TwitchGames
//
//  Created by Piera Marchesini on 23/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit
import Reachability

public protocol NetworkStatusListener : class {
    func networkStatusDidChange(status: Reachability.Connection)
}

class ReachabilityManager: NSObject {

    static  let shared = ReachabilityManager()
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .none
    }
    var reachabilityStatus: Reachability.Connection = .none
    let reachability = Reachability()!
    var listeners = [NetworkStatusListener]()
    
    @objc
    func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .none:
            debugPrint("Network became unreachable")
        case .wifi:
            debugPrint("Network reachable through WiFi")
        case .cellular:
            debugPrint("Network reachable through Cellular Data")
        }
        
        for listener in listeners {
            listener.networkStatusDidChange(status: reachability.connection)
        }
    }
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: Notification.Name.reachabilityChanged,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.reachabilityChanged,
                                                  object: reachability)
    }
    
    func addListener(listener: NetworkStatusListener){
        listeners.append(listener)
    }
    
    func removeListener(listener: NetworkStatusListener){
        listeners = listeners.filter{ $0 !== listener}
    }
}
