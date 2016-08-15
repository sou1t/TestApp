//
//  SuccessViewController.swift
//  QuizApp
//
//  Created by Виталий Волков on 19.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit
import Chirp
import Flurry_iOS_SDK

class SuccessViewController: UIViewController {
    

    let def = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var score: UILabel!

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.prepareSound(fileName: "win.mp3")
            Chirp.sharedManager.prepareSound(fileName: "tapMenu.mp3")
        }
        var ArrayOfSuccess:Array<Int>
        ArrayOfSuccess = def.arrayForKey("SuccessLevels") as? Array<Int> ?? []
        let current = NSUserDefaults.standardUserDefaults().valueForKey("level") as? Int ?? 10
        ArrayOfSuccess.append(current)
        def.setObject(ArrayOfSuccess, forKey: "SuccessLevels")
        let currentScore = NSUserDefaults.standardUserDefaults().valueForKey("score") as? String ?? "0"
        NSUserDefaults.standardUserDefaults().setValue("\(Int(currentScore)!+50)", forKey: "score")
        score.text = NSUserDefaults.standardUserDefaults().valueForKey("score") as? String ?? "0"
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.playSound(fileName: "win.mp3")
        }
        
        let delay = 8.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()){
            playBackgroundMusic("fon")
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func NextClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.playSound(fileName: "tapMenu.mp3")
        }
        let current = NSUserDefaults.standardUserDefaults().valueForKey("level") as? Int ?? 10
        def.setInteger((current+1)*5, forKey: "numberOfLevels")
        NSUserDefaults.standardUserDefaults().setInteger(current+1, forKey: "level")
        Flurry.logEvent("User go to level \(current+1)")
        self.performSegueWithIdentifier("SuccessToQuestion", sender: self)
    }
    
    @IBAction func RepeatClicked(sender: AnyObject) {
        let current = NSUserDefaults.standardUserDefaults().valueForKey("level") as? Int ?? 10
        Flurry.logEvent("User repeat level \(current)")
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.playSound(fileName: "tapMenu.mp3")
        }
        self.performSegueWithIdentifier("SuccessToQuestion", sender: self)
    }
    
    @IBAction func ListOfLevelsClicked(sender: AnyObject) {
        Flurry.logEvent("User go to list of levels")
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.playSound(fileName: "tapMenu.mp3")
        }
               self.performSegueWithIdentifier("SuccessToLevels", sender: self)
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        Chirp.sharedManager.removeSound(fileName: "win.mp3")
        Chirp.sharedManager.removeSound(fileName: "tapMenu.mp3")
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
