//
//  ViewController.swift
//  QuizApp
//
//  Created by Виталий Волков on 15.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
    
    let def = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let successArr = def.arrayForKey("SuccessLevels") as? Array<Int> ?? []
        let arrButton = [n1, n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,n13,n14,n15,n16]
        
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
    
    @IBAction func LevelSelect(sender: UIButton) {
        
        def.setInteger((sender.tag-1)*10, forKey: "startValue")
        def.setInteger(sender.tag*10, forKey: "topValue")
        self.performSegueWithIdentifier("goToQuestion", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }


}

