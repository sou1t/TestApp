//
//  FailViewController.swift
//  QuizApp
//
//  Created by Виталий Волков on 19.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit

class FailViewController: UIViewController {
    @IBOutlet weak var score: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidAppear(true)
        score.text = NSUserDefaults.standardUserDefaults().valueForKey("score") as? String ?? "0"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ListOfLevelsClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("FailToLevels", sender: self)
    }
    
    @IBAction func RepeatClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("FailToQuestion", sender: self)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    


    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(10, delay: 1.0, options: .AllowAnimatedContent , animations: {
            
            let image: UIImage = UIImage(named: "Block2Fail")!
            let bgImage = UIImageView(image: image)
            bgImage.frame = CGRectMake(0,0,60,60)
            self.view.addSubview(bgImage)
            let f1 = bgImage.frame

            bgImage.center.y += f1.height
            
            }, completion: { finished in
                                print("finished")
                        })
    }

}
