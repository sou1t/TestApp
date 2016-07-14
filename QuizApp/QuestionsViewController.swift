//
//  QuestionsViewController.swift
//  QuizApp
//
//  Created by Виталий Волков on 19.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit
import SDWebImage

class QuestionsViewController: UIViewController {
    
    @IBOutlet weak var BackGround: UIImageView!
    
    
    @IBOutlet weak var QuestionConstraint: NSLayoutConstraint!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var QuestionNumber: UILabel!
    var coins = NSUserDefaults.standardUserDefaults().valueForKey("coins") as? String ?? "0"
    @IBOutlet weak var BgForPic: UIImageView!
    @IBOutlet weak var Photo: UIImageView!
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var Answer1: UIButton!
    @IBOutlet weak var Answer2: UIButton!
    @IBOutlet weak var Answer4: UIButton!
    @IBOutlet weak var Answer3: UIButton!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var CoinsLabel: UILabel!
    var questions: Array<Question> = []
    let def = NSUserDefaults.standardUserDefaults()
    var questioNum = Int(arc4random_uniform(UInt32(8)))
    var numOfLevels = NSUserDefaults.standardUserDefaults().valueForKey("numberOfLevels") as? Int ?? 0
    var lives = 1
    var i = 1
    var isCheating = false
    //let toplevel = NSUserDefaults.standardUserDefaults().valueForKey("topValue") as? Int ?? 10

    
    override func viewDidLoad() {
        super.viewDidLoad()
        def.setValue(self.QuestionConstraint.constant, forKey: "defaultPos")
        score.text = def.valueForKey("score") as? String ?? "0"
        CoinsLabel.text = coins
        updateUI(questioNum)
        // Do any additional setup after loading the view.
    }

    @IBAction func GetGoldClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("QuestionToCoins", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var timer = NSTimer() //make a timer variable, but do do anything yet
    let timeInterval:NSTimeInterval = 0.05
    var timeCount:NSTimeInterval = 13.0
    let timerEnd:NSTimeInterval = 13.0

    
    func updateUI(questionNum:Int){
        isCheating = false
        if (numOfLevels>0 && lives>=1) {
        numOfLevels += -1
        timeCount = 13.0
        if(!timer.valid){
        TimeLabel.text = timeString(timeCount)
        timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval,
                                                       target: self,
                                                       selector: #selector(QuestionsViewController.timerDidEnd(_:)),
                                                       userInfo: "0",
                                                       repeats: true)
        
        }
        
        
        
        
            
        
            QuestionModel().GetQuestions{
                (result) ->() in
                for item in result.array!
                {
                    let AnswersString = item["Answers"].string
                    let AnswerArray = AnswersString!.componentsSeparatedByString("; ")
                    print(item["Question"].string!)
                    print(AnswerArray)
                    print(item["CorrectAnswer"].string!)
                    self.questions.append(Question(question:item["Question"].string!, answers:AnswerArray, correctAnswerIndex:Int(item["CorrectAnswer"].string!)!, type: item["Type"].string!, photoURL: item["PhotoURL"].string!))

                }
                if(self.questions[questionNum].photoURL != "no")
                {
                    print(self.QuestionLabel.center.y)
                    
                    self.Photo.hidden = false
                    let url = NSURL(string: self.questions[questionNum].photoURL)
                    self.Photo.sd_setImageWithURL(url)
                    UIView.animateWithDuration(0.5, delay: 0.5, options: .AllowAnimatedContent , animations: {
                        self.def.setValue(self.QuestionLabel.center.y, forKey: "QuestCenter")
                        
                        self.QuestionConstraint.constant = self.def.valueForKey("defaultPos") as? CGFloat ?? 0.0
                        
                        }, completion: { finished in
                            print("finished")
                    })
                    
                }
                else
                {
                    
                    UIView.animateWithDuration(0.5, delay: 0.5, options: .AllowAnimatedContent , animations: {
                        self.def.setValue(self.QuestionLabel.center.y, forKey: "QuestCenter")
                        
                        self.QuestionConstraint.constant = self.view.center.y-70.0
                        
                        }, completion: { finished in
                            print("finished")
                    })
                    
                    self.Photo.hidden = true
                }
                let NumOfLevels = NSUserDefaults.standardUserDefaults().valueForKey("numberOfLevels") as? Int ?? 0
                self.QuestionLabel.text = self.questions[questionNum].question
                self.QuestionNumber.text = "\(self.i)/\(NumOfLevels)"
                self.Answer1.setTitle(self.questions[questionNum].answers[0], forState: .Normal)
                self.Answer2.setTitle(self.questions[questionNum].answers[1], forState: .Normal)
                self.Answer3.setTitle(self.questions[questionNum].answers[2], forState: .Normal)
                self.Answer4.setTitle(self.questions[questionNum].answers[3], forState: .Normal)
                self.Answer1.setBackgroundImage(UIImage(named: "QuestionButton"), forState: .Normal)
                self.Answer2.setBackgroundImage(UIImage(named: "QuestionButton"), forState: .Normal)
                self.Answer3.setBackgroundImage(UIImage(named: "QuestionButton"), forState: .Normal)
                self.Answer4.setBackgroundImage(UIImage(named: "QuestionButton"), forState: .Normal)
                self.Answer1.enabled = true
                self.Answer2.enabled = true
                self.Answer3.enabled = true
                self.Answer4.enabled = true
            }
        
        }
        else
        {
            if (lives>=1) {
                timer.invalidate()
                self.performSegueWithIdentifier("Ok", sender: self)
            }
            else
            {
                timer.invalidate()
                self.performSegueWithIdentifier("Fail", sender: self)
            }

        }
    }

    
    
    
    
    @IBAction func AnswerSelect(sender: UIButton) {
        Answer1.enabled = false
        Answer2.enabled = false
        Answer3.enabled = false
        Answer4.enabled = false
        let buttons = [Answer1, Answer2, Answer3, Answer4]
        
        if (questions[questioNum].isGuessCorrect(sender.tag)){
            
            sender.setBackgroundImage(UIImage(named: "RightQuestion"), forState: .Normal)
            questioNum = Int(arc4random_uniform(UInt32(8)))
            i += 1
            let delay = 1.5 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.updateUI(self.questioNum)
            }
            
            }
        else{
            if (isCheating)
            {
                sender.setBackgroundImage(UIImage(named: "WrongQuestion"), forState: .Normal)
                isCheating = false
            }
            else
            {
                sender.setBackgroundImage(UIImage(named: "WrongQuestion"), forState: .Normal)
                let rightNum = questions[questioNum].correctAnswerIndex
                for button in buttons
                {
                    if(button.tag == rightNum+1)
                    {
                        let delay = 0.75 * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue()) {
                            button.setBackgroundImage(UIImage(named: "RightQuestion"), forState: .Normal)
                            let delay2 = 0.4 * Double(NSEC_PER_SEC)
                            let time2 = dispatch_time(DISPATCH_TIME_NOW, Int64(delay2))
                            dispatch_after(time2, dispatch_get_main_queue()) {
                                button.setBackgroundImage(UIImage(named: "QuestionButton"), forState: .Normal)
                                let time3 = dispatch_time(DISPATCH_TIME_NOW, Int64(delay2))
                                dispatch_after(time3, dispatch_get_main_queue()) {
                                    button.setBackgroundImage(UIImage(named: "RightQuestion"), forState: .Normal)
                                    let time4 = dispatch_time(DISPATCH_TIME_NOW, Int64(delay2))
                                    dispatch_after(time4, dispatch_get_main_queue()) {
                                        button.setBackgroundImage(UIImage(named: "QuestionButton"), forState: .Normal)
                                        let time5 = dispatch_time(DISPATCH_TIME_NOW, Int64(delay2))
                                        dispatch_after(time5, dispatch_get_main_queue()) {
                                            button.setBackgroundImage(UIImage(named: "RightQuestion"), forState: .Normal)
                                        }

                                    }

                                }

                            }
                        }

                        
                        
                        
                        
                    }
                }
                lives += -1
                questioNum = Int(arc4random_uniform(UInt32(8)))
                i += 1
                let delay = 2.9 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.updateUI(self.questioNum)
                }
            }
            
            
        }
        
    }


    func timerDidEnd(timer:NSTimer){
        timeCount = timeCount - timeInterval
        if (timeCount <= 0)
        {
            
            TimeLabel.text = "00"
            
            let buttons = [Answer1, Answer2, Answer3, Answer4]
            let rightNum = questions[questioNum].correctAnswerIndex
            for button in buttons
            {
                if(button.tag == rightNum+1)
                {
                    button.setBackgroundImage(UIImage(named: "RightQuestion"), forState: .Normal)
                }
            }
            lives += -1
            i += 1
            questioNum = Int(arc4random_uniform(UInt32(6)))
            let delay = 1.5 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.updateUI(self.questioNum)
            }
            timeCount = 13.0
        }
        else
        {
            TimeLabel.text = timeString(timeCount)
        }
        
    }
    func timeString(time:NSTimeInterval) -> String {
        
        let seconds = Int(time) % 60
        return String(format:"%02i",Int(seconds))
    }
    
    @IBAction func HelpPlusLive(sender: UIButton) {
        sender.enabled = false
        timeCount = 11
        isCheating = true
        
    }
    
    @IBAction func HelpCheat(sender: UIButton) {
        sender.enabled = false
        timeCount += 10
        let delay = 7 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            sender.enabled = true
        }

    }
    
    @IBAction func Help5050(sender: UIButton) {
        sender.enabled = false
        timeCount = 11
        let buttons = [Answer1, Answer2, Answer3, Answer4]
        let rightNum = questions[questioNum].correctAnswerIndex
        var but: Array<UIButton> = []
        var i = 0
        for button in buttons
        {
            if(button.tag != rightNum+1 && i<=1)
            {
                i += 1
                but.append(button)
                
            }
            
        }
        for bu in but
        {
            bu.enabled = false
            bu.setTitle("", forState: .Normal)
        }


        
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
