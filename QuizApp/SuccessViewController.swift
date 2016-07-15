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

    @IBOutlet weak var score: UILabel!

    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        var ArrayOfSuccess:Array<Int>
        ArrayOfSuccess = def.arrayForKey("SuccessLevels") as? Array<Int> ?? []
        let current = NSUserDefaults.standardUserDefaults().valueForKey("level") as? Int ?? 10
        ArrayOfSuccess.append(current)
        def.setObject(ArrayOfSuccess, forKey: "SuccessLevels")
        let currentScore = NSUserDefaults.standardUserDefaults().valueForKey("score") as? String ?? "0"
        NSUserDefaults.standardUserDefaults().setValue("\(Int(currentScore)!+50)", forKey: "score")
        score.text = NSUserDefaults.standardUserDefaults().valueForKey("score") as? String ?? "0"

        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func NextClicked(sender: AnyObject) {
        let current = NSUserDefaults.standardUserDefaults().valueForKey("level") as? Int ?? 10
        def.setInteger((current+1)*5, forKey: "numberOfLevels")
        NSUserDefaults.standardUserDefaults().setInteger(current+1, forKey: "level")
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
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
