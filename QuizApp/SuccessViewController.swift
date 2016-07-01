//
//  SuccessViewController.swift
//  QuizApp
//
//  Created by Виталий Волков on 19.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {

    let def = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var ArrayOfSuccess:Array<Int>
        ArrayOfSuccess = def.arrayForKey("SuccessLevels") as? Array<Int> ?? []
        let current = NSUserDefaults.standardUserDefaults().valueForKey("topValue") as? Int ?? 10
        ArrayOfSuccess.append(current/10)
        def.setObject(ArrayOfSuccess, forKey: "SuccessLevels")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func NextClicked(sender: AnyObject) {
        let current = NSUserDefaults.standardUserDefaults().valueForKey("topValue") as? Int ?? 10
        NSUserDefaults.standardUserDefaults().setInteger(current, forKey: "startValue")
        NSUserDefaults.standardUserDefaults().setInteger(current+10, forKey: "topValue")
        self.performSegueWithIdentifier("SuccessToQuestion", sender: self)
    }
    
    @IBAction func RepeatClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("SuccessToQuestion", sender: self)
    }
    
    @IBAction func ListOfLevelsClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("SuccessToLevels", sender: self)
        

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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
