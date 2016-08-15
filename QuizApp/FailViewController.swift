//
//  FailViewController.swift
//  QuizApp
//
//  Created by Виталий Волков on 19.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit
import Chirp
import Flurry_iOS_SDK

class FailViewController: UIViewController {
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var bg1: UIImageView!
    @IBOutlet weak var bg2: UIImageView!
    @IBOutlet weak var bg3: UIImageView!
    @IBOutlet weak var bg4: UIImageView!
    @IBOutlet weak var bg5: UIImageView!
    
    
    var timer:NSTimer{
        return NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: #selector(FailViewController.Animate), userInfo: nil, repeats: true)
    }
    let def = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.prepareSound(fileName: "tapMenu.mp3")
        }
        def.setValue(self.bg1.center.y, forKey: "1")
        def.setValue(self.bg2.center.y, forKey: "2")
        def.setValue(self.bg3.center.y, forKey: "3")
        def.setValue(self.bg4.center.y, forKey: "4")
        def.setValue(self.bg5.center.y, forKey: "5")
        viewDidAppear(true)
        score.text = NSUserDefaults.standardUserDefaults().valueForKey("score") as? String ?? "0"
        self.timer.fire()
        
        let delay = 8.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()){
            playBackgroundMusic("fon")
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ListOfLevelsClicked(sender: AnyObject) {
        Flurry.logEvent("User go to list of levels")
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.playSound(fileName: "tapMenu.mp3")
        }
        self.timer.invalidate()
        self.performSegueWithIdentifier("FailToLevels", sender: self)
    }
    
    @IBAction func RepeatClicked(sender: AnyObject) {
        let current = NSUserDefaults.standardUserDefaults().valueForKey("level") as? Int ?? 10
        Flurry.logEvent("User repeat level \(current)")
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.playSound(fileName: "tapMenu.mp3")
        }
        self.timer.invalidate()
        self.performSegueWithIdentifier("FailToQuestion", sender: self)
    }
    

    
    override func viewDidAppear(animated: Bool) {
            }
    func Animate(){
        UIView.animateWithDuration(14.0, delay: 0.0, options: .CurveLinear , animations: {
            
            
            self.bg1.center.y += 900.0
            self.bg2.center.y += 900.0
            self.bg3.center.y += 900.0
            self.bg4.center.y += 900.0
            self.bg5.center.y += 900.0
            
            
            }, completion: { finished in
                self.bg1.center.y = self.def.valueForKey("1") as! CGFloat
                self.bg2.center.y = self.def.valueForKey("2") as! CGFloat
                self.bg3.center.y = self.def.valueForKey("3") as! CGFloat
                self.bg4.center.y = self.def.valueForKey("4") as! CGFloat
                self.bg5.center.y = self.def.valueForKey("5") as! CGFloat

        })
        
        
        
    }
    deinit{
        Chirp.sharedManager.removeSound(fileName: "tapMenu.mp3")
    }
    



}
