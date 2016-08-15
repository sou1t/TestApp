//
//  ViewController.swift
//  QuizApp
//
//  Created by Виталий Волков on 15.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit
import GameKit
import GoogleMobileAds
import Alamofire
import Chirp
import Flurry_iOS_SDK

class ViewController: UIViewController, GKGameCenterControllerDelegate {
    @IBOutlet weak var score: UILabel!
    var coins = NSUserDefaults.standardUserDefaults().valueForKey("coins") as? String ?? "0"
    @IBOutlet weak var n1: UIButton!
    @IBOutlet weak var n2: UIButton!
    @IBOutlet weak var n3: UIButton!
    @IBOutlet weak var n4: UIButton!
    @IBOutlet weak var n6: UIButton!
    @IBOutlet weak var n5: UIButton!
    @IBOutlet weak var n7: UIButton!
    @IBOutlet weak var n8: UIButton!
    @IBOutlet weak var n9: UIButton!
    @IBOutlet weak var n10: UIButton!
    @IBOutlet weak var n12: UIButton!
    @IBOutlet weak var n11: UIButton!
    @IBOutlet weak var n16: UIButton!
    @IBOutlet weak var n14: UIButton!
    @IBOutlet weak var n15: UIButton!
    @IBOutlet weak var n13: UIButton!
    @IBOutlet weak var coinsLabel: UILabel!

    //constants
    @IBOutlet weak var Const2to1: NSLayoutConstraint!
    @IBOutlet weak var Constant4up: NSLayoutConstraint!
    @IBOutlet weak var Const6up: NSLayoutConstraint!
    @IBOutlet weak var Const5up: NSLayoutConstraint!
    @IBOutlet weak var Const7up: NSLayoutConstraint!
    @IBOutlet weak var Const10down: NSLayoutConstraint!
    @IBOutlet weak var Const8up: NSLayoutConstraint!
    @IBOutlet weak var Const9up: NSLayoutConstraint!
    @IBOutlet weak var Const12down: NSLayoutConstraint!
    @IBOutlet weak var Const11down: NSLayoutConstraint!
    @IBOutlet weak var Const13down: NSLayoutConstraint!
    @IBOutlet weak var Const15to16: NSLayoutConstraint!
    @IBOutlet weak var Const14down: NSLayoutConstraint!
    @IBOutlet weak var Const15down: NSLayoutConstraint!
    @IBOutlet weak var Const16down: NSLayoutConstraint!
    @IBOutlet weak var Const6left: NSLayoutConstraint!
    @IBOutlet weak var Const12left: NSLayoutConstraint!
    @IBOutlet weak var Const8left: NSLayoutConstraint!
    @IBOutlet weak var Const14left: NSLayoutConstraint!
    var startTime: CFAbsoluteTime!
    var iphone = "iPhone 6"
    
    
    let def = NSUserDefaults.standardUserDefaults()
    
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
    override func viewDidLoad() {
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.prepareSound(fileName: "tapMenu.mp3")
            Chirp.sharedManager.prepareSound(fileName: "coins.mp3")
        }
        playBackgroundMusic("fon")
        super.viewDidLoad()
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = "+10 монет"
        notification.alertAction = "Потяните, чтобы зайти"
        notification.fireDate = NSDate.init(timeIntervalSinceNow: 60*60*24*2)
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        CheckInternet()
        if(DeviceType.IS_IPHONE_4_OR_LESS){
            iphone = "iPhone 4"
            UIView.animateWithDuration(0.01, delay: 0.0, options: .CurveLinear , animations: {
                self.Const2to1.constant += 25.0
                self.Constant4up.constant += 23.0
                self.Const6up.constant += 47.0
                self.Const5up.constant += 47.0
                self.Const7up.constant += 73.0
                self.Const10down.constant += 73.0
                self.Const8up.constant += 90.0
                self.Const9up.constant += 90.0
                self.Const12down.constant += 50.0
                self.Const11down.constant += 50.0
                self.Const13down.constant += 23.0
                self.Const14down.constant += 6.0
                self.Const15down.constant += 6.0
                self.Const15to16.constant += 25.0
                self.Const16down.constant += 6.0
                self.Const6left.constant += 25.0
                self.Const12left.constant += 25.0
                self.Const8left.constant += 25.0
                self.Const14left.constant += 9.0
                
                }, completion: { finished in
                    print("iphone4.OK!")
            })
        }
        if(DeviceType.IS_IPHONE_5){
                iphone = "iPhone 5"
            UIView.animateWithDuration(0.01, delay: 0.0, options: .CurveLinear , animations: {
                
                self.Const2to1.constant += 25.0
                self.Constant4up.constant += 12.0
                self.Const6up.constant += 26.0
                self.Const5up.constant += 26.0
                self.Const7up.constant += 40.0
                self.Const10down.constant += 37.0
                self.Const8up.constant += 47.0
                self.Const9up.constant += 47.0
                self.Const12down.constant += 29.0
                self.Const11down.constant += 29.0
                self.Const13down.constant += 23.0
                self.Const14down.constant += 6.0
                self.Const15down.constant += 6.0
                self.Const15to16.constant += 25.0
                self.Const16down.constant += 6.0
                self.Const6left.constant += 25.0
                self.Const12left.constant += 25.0
                self.Const8left.constant += 25.0
                self.Const14left.constant += 9.0
                
                }, completion: { finished in
                    print("iphone5.OK!")
            })
        }
        if(DeviceType.IS_IPHONE_6P){
                self.iphone = "iPhone 6Plus"
            UIView.animateWithDuration(0.01, delay: 0.0, options: .CurveLinear , animations: {
                
                self.Const2to1.constant += -25.0
                self.Constant4up.constant += -10.0
                self.Const6up.constant += -17.0
                self.Const5up.constant += -17.0
                self.Const7up.constant += -20.0
                self.Const10down.constant += -27.0
                self.Const8up.constant += -34.0
                self.Const9up.constant += -34.0
                self.Const12down.constant += -17.0
                self.Const11down.constant += -17.0
                self.Const13down.constant += -10.0
                self.Const15to16.constant += 25.0
                self.Const6left.constant += -25.0
                self.Const12left.constant += -25.0
                self.Const8left.constant += -25.0
                self.Const14left.constant += -25.0
                self.Const15to16.constant += -30.0
                
                }, completion: { finished in
                    print("iphone6p.OK!")
            })
        }
        
        authLocalPlayer()
        self.navigationController?.navigationBar.hidden = true
        let successArr = def.arrayForKey("SuccessLevels") as? Array<Int> ?? []
        let arrButton = [n1, n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,n13,n14,n15,n16]
        score.text = NSUserDefaults.standardUserDefaults().valueForKey("score") as? String ?? "0"
        if(successArr.isEmpty)
        {
            for button in arrButton{
                if(button.tag != 1){
                    button.enabled = false
                }
            }
        }
        for number in successArr
        {
            for button in arrButton
            {
                if (button.tag == number) {
                    button.setBackgroundImage(UIImage(named: "DoneCircle"), forState: .Normal)
                    button.setTitleColor(UIColor.blackColor(), forState: .Normal)
                }
                if(button.tag == Int(successArr.maxElement()!+1)){
                    
                button.setBackgroundImage(UIImage(named: "LastCircle"), forState: .Normal)
                    button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                }
                
                if (button.tag >= Int(successArr.maxElement()!+2)){
                    button.enabled = false
                }
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
        
        let dateNow = NSDate()
        if((def.valueForKey("savedDate") == nil)){
            Chirp.sharedManager.playSound(fileName: "coins.mp3")
            def.setValue(dateNow.timeIntervalSince1970, forKey: "savedDate")
            let new = Int(self.coins)! + 10
            self.def.setValue("\(new)", forKey: "coins")
            SweetAlert().showAlert("Ежедневный бонус!", subTitle: "Вы получаете 10 монет.", style: AlertStyle.CustomImag(imageFile: "goldIco"))
        }

        let Saved = def.valueForKey("savedDate") as? NSTimeInterval ?? dateNow.timeIntervalSince1970
        
        let NowInerval = dateNow.timeIntervalSince1970
        let deference = NowInerval - Saved
        let interval: NSTimeInterval = 24*60*60
        print("!!!!!!!!!!!!\(deference)!!!!!!!!!!!!!!!!")
        if (deference >= interval){
            Flurry.logEvent("User get gold bonus")
            Chirp.sharedManager.playSound(fileName: "coins.mp3")
            def.setValue(dateNow.timeIntervalSince1970, forKey: "savedDate")
            let new = Int(self.coins)! + 10
            self.def.setValue("\(new)", forKey: "coins")
            Flurry.logEvent("User get gold bonus and now has \(new) gold")
            SweetAlert().showAlert("Ежедневный бонус!", subTitle: "Вы получаете 10 монет.", style: AlertStyle.CustomImag(imageFile: "goldIco"))
        }
        
        UIView.animateWithDuration(1.5, delay: 4.0, options: .AllowAnimatedContent , animations: {
            self.coinsLabel.text = self.def.valueForKey("coins") as? String ?? "0"
            
            }, completion: { finished in
                print("finished")
        })
        let articleParams = ["Gold": coinsLabel.text!, "Score": score.text!, "Number of comleted levels": "\(successArr.count)", "iPhone version": iphone]
        
        Flurry.logEvent("User at main page", withParameters: articleParams)
    }
    
    @IBAction func RatingButtonClicked(sender: UIButton) {
        let scoreNum = Int(score.text!)
        saveHightscore(scoreNum!)
        ShowLeaderboard()
        Flurry.logEvent("User go to rating page")
    }
    
    
    
    
    
    @IBAction func LevelSelect(sender: UIButton) {
        Flurry.logEvent("User selected \(sender.tag) level")
        Chirp.sharedManager.playSound(fileName: "tapMenu.mp3")
        def.setInteger(sender.tag, forKey: "level")
        def.setInteger(sender.tag*5, forKey: "numberOfLevels")
        self.performSegueWithIdentifier("goToQuestion", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func GetGoldClicked(sender: AnyObject) {
        Flurry.logEvent("User go to 'get gold' page")
        Chirp.sharedManager.playSound(fileName: "tapMenu.mp3")
        self.performSegueWithIdentifier("MainToCoins", sender: self)
    }

    
    //Init game center
    func authLocalPlayer(){
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {
            (viewController, error) -> Void in
            if(viewController != nil){
                self.presentViewController(viewController!, animated:true, completion: nil)
            }
            else
            {
                print(GKLocalPlayer.localPlayer().authenticated)
            }
        }
    }
    
    //Save score to leaderboard
    func saveHightscore(score:Int){
        
        //check if the user is signed in
        if GKLocalPlayer.localPlayer().authenticated{
            
            let scoreReporter = GKScore(leaderboardIdentifier: "quiz.lead")
            scoreReporter.value = Int64(score)
            
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError?) -> Void in
                if error != nil{
                    print("error in save")
                }
            })
        }
    }
    
    //Show leaderboard
    func ShowLeaderboard(){
        Chirp.sharedManager.playSound(fileName: "tapMenu.mp3")
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    //Hide Game Center
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func CheckInternet() {
        ConnectionHelper().isInternetConnected() { internetConnected in
            if internetConnected {
                print("Internet OK")
            } else {
                SweetAlert().showAlert("Проверьте интернет соединение", subTitle: "Нет интернет подключения!", style: AlertStyle.Warning, buttonTitle:"", buttonColor:self.UIColorFromRGB(0xDD6B55) , otherButtonTitle:  "Повторить попытку", otherButtonColor: self.UIColorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
                    if isOtherButton == true {
                        
                        print("Cancel Button  Pressed")
                    }
                    else {
                        self.CheckInternet()
                    }
            }
        }
    }
    
    
    }
    
    deinit {
        Chirp.sharedManager.removeSound(fileName: "coins.mp3")
        Chirp.sharedManager.removeSound(fileName: "tapMenu.mp3")

    }
}

enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}
