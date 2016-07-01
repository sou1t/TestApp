//
//  QuestionsViewController.swift
//  QuizApp
//
//  Created by Виталий Волков on 19.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController {
    @IBOutlet weak var QuestionNumber: UILabel!
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var Answer1: UIButton!
    @IBOutlet weak var Answer2: UIButton!
    @IBOutlet weak var Answer4: UIButton!
    @IBOutlet weak var Answer3: UIButton!
    @IBOutlet weak var TimeLabel: UILabel!
    
    let def = NSUserDefaults.standardUserDefaults()
   
    var questioNum = NSUserDefaults.standardUserDefaults().valueForKey("startValue") as? Int ?? 0
    var lives = 3
    let toplevel = NSUserDefaults.standardUserDefaults().valueForKey("topValue") as? Int ?? 10

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(questioNum)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var timer = NSTimer() //make a timer variable, but do do anything yet
    let timeInterval:NSTimeInterval = 0.05
    var timeCount:NSTimeInterval = 11.0
    let timerEnd:NSTimeInterval = 11.0
    
    func updateUI(questionNum:Int){
        if (questioNum < toplevel && lives>=1) {
        timeCount = 11.0
        if(!timer.valid){
        TimeLabel.text = timeString(timeCount)
        timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval,
                                                       target: self,
                                                       selector: #selector(QuestionsViewController.timerDidEnd(_:)),
                                                       userInfo: "0",
                                                       repeats: true)
        
        }
        
        
        
        
        
        let Model = QuestionModel()
        let questions = Model.questions
        QuestionLabel.text = questions[questionNum].question            
        QuestionNumber.text = "\(questionNum+1)/10"
        Answer1.setTitle(questions[questionNum].answers[0], forState: .Normal)
        Answer2.setTitle(questions[questionNum].answers[1], forState: .Normal)
        Answer3.setTitle(questions[questionNum].answers[2], forState: .Normal)
        Answer4.setTitle(questions[questionNum].answers[3], forState: .Normal)
        Answer1.setBackgroundImage(UIImage(named: "QuestionButton"), forState: .Normal)
        Answer2.setBackgroundImage(UIImage(named: "QuestionButton"), forState: .Normal)
        Answer3.setBackgroundImage(UIImage(named: "QuestionButton"), forState: .Normal)
        Answer4.setBackgroundImage(UIImage(named: "QuestionButton"), forState: .Normal)
        }
        else
        {
            if (lives>=1) {
                timeCount = 11.0
                self.performSegueWithIdentifier("Ok", sender: self)
            }
            else
            {
                timeCount = 11.0
                self.performSegueWithIdentifier("Fail", sender: self)
            }

        }
    }

    @IBAction func AnswerSelect(sender: UIButton) {
        let buttons = [Answer1, Answer2, Answer3, Answer4]
        let Model = QuestionModel()
        let questions = Model.questions
        
        if (questions[questioNum].isGuessCorrect(sender.tag)){
            
            sender.setBackgroundImage(UIImage(named: "RightQuestion"), forState: .Normal)
            questioNum += 1
            let delay = 1.5 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.updateUI(self.questioNum)
            }
            
            }
        else{
            sender.setBackgroundImage(UIImage(named: "WrongQuestion"), forState: .Normal)
            let rightNum = questions[questioNum].correctAnswerIndex
            for button in buttons
            {
                if(button.tag == rightNum+1)
                {
                    button.setBackgroundImage(UIImage(named: "RightQuestion"), forState: .Normal)
                }
            }
            lives += -1
            questioNum += 1
            let delay = 1.5 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.updateUI(self.questioNum)
            }
            
        }
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    func timerDidEnd(timer:NSTimer){
        timeCount = timeCount - timeInterval
        if (timeCount <= 0)
        {
            
            TimeLabel.text = "!!!"
            
            let buttons = [Answer1, Answer2, Answer3, Answer4]
            let Model = QuestionModel()
            let questions = Model.questions
            let rightNum = questions[questioNum].correctAnswerIndex
            for button in buttons
            {
                if(button.tag == rightNum+1)
                {
                    button.setBackgroundImage(UIImage(named: "RightQuestion"), forState: .Normal)
                }
            }
            lives += -1
            questioNum += 1
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
        if (seconds > 10)
        {
            return "!!!"
        }
        else
        {
        return String(format:"%02i",Int(seconds))
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
