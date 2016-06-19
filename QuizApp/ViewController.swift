//
//  ViewController.swift
//  QuizApp
//
//  Created by Виталий Волков on 15.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let def = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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


}

