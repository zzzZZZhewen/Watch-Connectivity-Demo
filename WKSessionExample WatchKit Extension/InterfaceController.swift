//
//  InterfaceController.swift
//  WKSessionExample WatchKit Extension
//
//  Created by 缪哲文 on 16/1/24.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            
            let answer = try?session.updateApplicationContext(["a" : "b"])
            
            
            session.sendMessage(["c":"d"], replyHandler: { (message) -> Void in
                print("reply")
                print(session.reachable)
                }, errorHandler: { (error) -> Void in
                print("error")
                print(session.reachable)
            })
            
            
        }
        
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
