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

    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activateSession()
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
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

    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        if let number = applicationContext["updateNumber"] as? Int {
            recievedLabel.setText("updateNubmer: \(number)")
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        dispatch_async(dispatch_get_main_queue()) {
            if let number = message["sendNumber"] as? Int {
                self.recievedLabel.setText("sendNumber: \(number)")
                replyHandler(["replyNumber": number + 1])
            }
            self.recievedImage.setImage(nil)
        }
    }
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        if let number = userInfo["userInfoNumber"] as? Int {
            recievedLabel.setText("userInfoNumber: \(number)")
        }
    }
    
    func session(session: WCSession, didReceiveFile file: WCSessionFile) {
        if let imageData = NSData(contentsOfURL: file.fileURL){
            recievedImage.setImage(UIImage(data: imageData))
        } else {
            print("not a valid image file url")
        }
        
        if let number = file.metadata?["fileNumber"] as? Int {
            self.recievedLabel.setText("fileNumber: \(number)")
        }
    }
    
    @IBOutlet var recievedLabel: WKInterfaceLabel!
    @IBOutlet var recievedImage: WKInterfaceImage!
    
}
