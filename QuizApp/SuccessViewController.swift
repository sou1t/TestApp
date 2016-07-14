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
    //    var i:CGFloat = 0.01
//    var Arr:[UIImageView]{
//        return [l1, l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14,l15,l16,l17,l18,l19,l20, l21, l22]
//    }
//    
//    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(SuccessViewController.RotateBack), userInfo: nil, repeats: true)
//        timer2 = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(SuccessViewController.dropFrames), userInfo: nil, repeats: true)
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
    
//    func RotateBack() {
//        UIView.animateWithDuration(0.01, delay: 0, options: .CurveLinear, animations: {
//            () -> Void in
//            for image in self.Arr{
//            let r = Int(arc4random_uniform(UInt32(1)))
//            switch r{
//            
//            case 0:
//                image.transform = CGAffineTransformMakeRotation(self.degree)
//            case 1:
//                image.transform = CGAffineTransformMakeRotation(-self.degree)
//            default:
//                image.transform = CGAffineTransformMakeRotation(self.degree)
//            }
//                
//            }
//            }, completion: {
//                (finished) -> Void in
//                self.degree += CGFloat(M_PI/180)
//                self.i += 1.0
//        })
//        
//    }
//    
//    func dropFrames() {
//        UIView.animateWithDuration(1.0, delay: 0, options: .CurveLinear, animations: {
//            () -> Void in
//            for image in self.Arr{
//                image.center.y += self.i
//            }
//            }, completion: {
//                (finished) -> Void in
//                self.i += 0.01
//        })
//
//    }


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
