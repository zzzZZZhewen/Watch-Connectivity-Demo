//
//  ViewController.swift
//  WKSessionExample
//
//  Created by 缪哲文 on 16/1/24.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    
    private var counter = 0
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil

    // 在入口控制器里初始化session
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        session?.delegate = self
        session?.activateSession()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        session?.delegate = self
        session?.activateSession()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!

    @IBAction func didIncreaseButtonTouchUpInside(sender: AnyObject) {
        counter++
        self.countLabel.text = String(counter)
    }
    
    @IBAction func didUpdateButtonTouchUpInside(sender: AnyObject) {
        if session != nil {
            do {
                try session?.updateApplicationContext(["updateNumber" : counter])
            } catch {
                print(error)
            }
            
        } else {
            print("session is nil in update however")
        }
        
    }
    
    @IBAction func didSendButtonTouchUpInside(sender: AnyObject) {
        if session != nil {
            // counterpart is active or can be activated
            if session!.reachable {
                session?.sendMessage(["sendNumber":counter],
                    replyHandler: { (reply) -> Void in
                        var number = reply["replyNumber"] as! Int
                        number++
                        self.replyLabel.text = String(number)
                    }, errorHandler: { (error) -> Void in
                        print(error)
                })
            } else {
                print("seesion.reachable == false")
            }
        } else {
            print("session is nil in send however")
        }
    }
    
    @IBAction func didUserInfoButtonTouchUpInside(sender: AnyObject) {
        if session != nil {
            session?.transferUserInfo(["userInfoNumber":counter])
        } else {
            print("session is nil in userInfo however")
        }
    }
    
    func session(session: WCSession, didFinishUserInfoTransfer userInfoTransfer: WCSessionUserInfoTransfer, error: NSError?) {
        print(error)
    }
    
    
    @IBAction func didFileButtonTouchUpInside(sender: AnyObject) {
        if session != nil {
            let filePath = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("avatar", ofType: "jpg")!)
            self.session?.transferFile(filePath, metadata: ["fileNumber":counter])
        } else {
            print("session is nil in file however")
        }
        
    }
    
    func session(session: WCSession, didFinishFileTransfer fileTransfer: WCSessionFileTransfer, error: NSError?) {
        print(error)
    }
    
}

