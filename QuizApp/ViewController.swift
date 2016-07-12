//
//  ViewController.swift
//  QuizApp
//
//  Created by Виталий Волков on 15.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit
import GameKit

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
    
    let def = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authLocalPlayer()
        self.navigationController?.navigationBar.hidden = true
        let successArr = def.arrayForKey("SuccessLevels") as? Array<Int> ?? []
        let arrButton = [n1, n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,n13,n14,n15,n16]
        score.text = NSUserDefaults.standardUserDefaults().valueForKey("score") as? String ?? "0"
        coinsLabel.text = coins
        for number in successArr
        {
            for button in arrButton
            {
                if (button.tag == number) {
                    button.setBackgroundImage(UIImage(named: "DoneCircle"), forState: .Normal)
                    button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                }
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func RatingButtonClicked(sender: UIButton) {
        let scoreNum = Int(score.text!)
        saveHightscore(scoreNum!)
        ShowLeaderboard()
    }
    
    
    
    
    
    @IBAction func LevelSelect(sender: UIButton) {
        def.setInteger(sender.tag, forKey: "level")
        def.setInteger(sender.tag*5, forKey: "numberOfLevels")
        self.performSegueWithIdentifier("goToQuestion", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    @IBAction func GetGoldClicked(sender: AnyObject) {
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
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    //Hide Game Center
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

