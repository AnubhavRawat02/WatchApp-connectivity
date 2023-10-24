//
//  WachConnectivityForWatch.swift
//  WatchApp1Watch Watch App
//
//  Created by Anubhav Rawat on 21/10/23.
//

import Foundation
import WatchConnectivity

class WachConnectivityForWatch: NSObject, WCSessionDelegate, ObservableObject{
    
    @Published var message: String = ""
//    @Published var applicationContext: [String: Any]? = nil
    @Published var contextMessage: String = ""
    @Published var userInfoString: String = ""
    
    @Published var receivedApplicationContextMessage: String = ""
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
        
        if let message = session.receivedApplicationContext["message"] as? String{
            contextMessage = message
        }
    }
    
//    receiving the immediate message from iphone
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            self.message = message["message"] as? String ?? "Unknown"
        }
        replyHandler(["message": "message received by the watch"])
    }
    
//    receiving application context
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let message = applicationContext["message"] as? String{
            self.contextMessage = message
        }
        if let message = session.receivedApplicationContext["message"] as? String{
            self.receivedApplicationContextMessage = message
        }
    }
    
//    background thread.
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        if let userInfoMessage = userInfo["message"] as? String{
            self.userInfoString = userInfoMessage
        }
    }
    
    
}
