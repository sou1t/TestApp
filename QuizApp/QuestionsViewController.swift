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
    
    
    
    func updateUI(questionNum:Int){
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

    @IBAction func AnswerSelect(sender: UIButton) {
        let buttons = [Answer1, Answer2, Answer3, Answer4]
        let Model = QuestionModel()
        let questions = Model.questions
        if (questioNum < toplevel-1 && lives>=1) {
        if (questions[questioNum].isGuessCorrect(sender.tag)){
            
            sender.setBackgroundImage(UIImage(named: "RightQuestion"), forState: .Normal)
            questioNum += 1
            let delay = 4.5 * Double(NSEC_PER_SEC)
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
        else
        {
            if (lives>=1) {
                self.performSegueWithIdentifier("Ok", sender: self)
            }
            else
            {
                self.performSegueWithIdentifier("Fail", sender: self)
            }
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
