//
//  QuestionsViewController.swift
//  QuizApp
//
//  Created by Виталий Волков on 19.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleMobileAds
import mopub_ios_sdk
import Chirp
import Flurry_iOS_SDK



class QuestionsViewController: UIViewController, MPInterstitialAdControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var BackGround: UIImageView!
    
    
    @IBOutlet weak var ConstraintForLetters: NSLayoutConstraint!

    @IBOutlet weak var Active: UIActivityIndicatorView!
    @IBOutlet weak var SplitToHide: UIImageView!
    @IBOutlet weak var Help50to50: UIButton!
    @IBOutlet weak var helpAddTime: UIButton!
    @IBOutlet weak var helpCanbeWrong: UIButton!
    
    @IBOutlet weak var AnswerSelectCV: UICollectionView!
    @IBOutlet weak var AnswerDisplayCV: UICollectionView!
    var interstitial: GADInterstitial!
    var right = false
    var iscorrect = "yes"
    var lettersToSelect: [String] = []
    var answersLetters:[String] = []
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
    var questioNum = Int(arc4random_uniform(UInt32(9)))
    var numOfLevels = NSUserDefaults.standardUserDefaults().valueForKey("numberOfLevels") as? Int ?? 0
    var lives = 2
    var i = 1
    var isCheating = false
    var interstitial1: MPInterstitialAdController =
        MPInterstitialAdController(forAdUnitId: "095a207910074051b61c64c78474069f")
    var l = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AnswerDisplayCV.hidden = true
        self.AnswerSelectCV.hidden = true
        self.QuestionLabel.hidden = true
        self.Answer1.hidden = true
        self.Answer2.hidden = true
        self.Answer3.hidden = true
        self.Answer4.hidden = true
        self.Active.hidden = false
        self.Active.startAnimating()
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.prepareSound(fileName: "WrongAnswer.mp3")
            Chirp.sharedManager.prepareSound(fileName: "CorrectAnswer.mp3")
            Chirp.sharedManager.prepareSound(fileName: "Help.mp3")
            Chirp.sharedManager.prepareSound(fileName: "tapMenu.mp3")
        }
        self.AnswerDisplayCV.hidden = true
        self.AnswerSelectCV.hidden = true
        //Init MoPub
        self.interstitial1.delegate = self
        self.interstitial1.loadAd()
        //Init GoogleAD
        createAndLoadInterstitial()
        def.setValue(self.QuestionConstraint.constant, forKey: "defaultPos")
        score.text = def.valueForKey("score") as? String ?? "0"
        CoinsLabel.text = coins
        updateUI(questioNum)
        UpdateHelpButtons()
    }

    @IBAction func GetGoldClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.playSound(fileName: "tapMenu.mp3")
        }
        self.performSegueWithIdentifier("QuestionToCoins", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }
    
    var timer = NSTimer() //make a timer variable, but do do anything yet
    let timeInterval:NSTimeInterval = 0.05
    var timeCount:NSTimeInterval = 13.0
    let timerEnd:NSTimeInterval = 13.0

    
    func updateUI(questionNum:Int){
        self.questions = []
        isCheating = false
        if (numOfLevels>0 && lives>=1) {
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
                    self.ConstraintForLetters.constant += -50.0
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
                
                let type = self.questions[questionNum].type
                
                switch type{
                    case "0":
                        self.numOfLevels += -1
                        self.timeCount = 13.0
                        if(!(self.timer).valid){
                            self.TimeLabel.text = self.timeString(self.timeCount)
                            self.timer = NSTimer.scheduledTimerWithTimeInterval(self.timeInterval,
                                target: self,
                                selector: #selector(QuestionsViewController.timerDidEnd(_:)),
                                userInfo: "0",
                                repeats: true)
                            
                        }
                        self.Help50to50.enabled = true
                        self.Active.hidden = true
                        self.QuestionLabel.hidden = false
                        self.AnswerDisplayCV.hidden = true
                        self.AnswerSelectCV.hidden = true
                        self.Answer1.hidden = false
                        self.Answer2.hidden = false
                        self.Answer3.hidden = false
                        self.Answer4.hidden = false
                        self.SplitToHide.hidden = false
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
                        break;
                    case "1":
                        self.numOfLevels += -1
                        self.timeCount = 15.0
                        if(!(self.timer).valid){
                            self.TimeLabel.text = self.timeString(self.timeCount)
                            self.timer = NSTimer.scheduledTimerWithTimeInterval(self.timeInterval,
                                target: self,
                                selector: #selector(QuestionsViewController.timerDidEnd(_:)),
                                userInfo: "0",
                                repeats: true)
                            
                        }
                        self.Help50to50.enabled = false
                        self.QuestionLabel.hidden = false
                        self.Active.hidden = true
                        self.Answer1.hidden = true
                        self.Answer2.hidden = true
                        self.Answer3.hidden = true
                        self.Answer4.hidden = true
                        self.SplitToHide.hidden = true
                        let string = self.questions[questionNum].answers[0]
                        
                        for letter in string.uppercaseString.characters
                        {
                            
                            self.lettersToSelect.append("\(letter)")
                            let rand = self.randomString(1)
                            self.lettersToSelect.append(rand)
                            self.answersLetters.append("0")
                        }
                        
                        self.def.setObject(self.lettersToSelect, forKey: "lettersToSelect")
                        self.def.setObject(self.answersLetters, forKey: "answersLetters")
                        self.AnswerDisplayCV.reloadData()
                        self.AnswerSelectCV.reloadData()
                        self.AnswerDisplayCV.hidden = false
                        self.AnswerSelectCV.hidden = false
                        break;
                default:
                    self.numOfLevels += -1
                    self.timeCount = 13.0
                    if(!(self.timer).valid){
                        self.TimeLabel.text = self.timeString(self.timeCount)
                        self.timer = NSTimer.scheduledTimerWithTimeInterval(self.timeInterval,
                            target: self,
                            selector: #selector(QuestionsViewController.timerDidEnd(_:)),
                            userInfo: "0",
                            repeats: true)
                        
                    }
                    self.Help50to50.enabled = true
                    self.QuestionLabel.hidden = false
                    self.Active.hidden = true
                    self.AnswerDisplayCV.hidden = true
                    self.AnswerSelectCV.hidden = true
                    self.Answer1.hidden = false
                    self.Answer2.hidden = false
                    self.Answer3.hidden = false
                    self.Answer4.hidden = false
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
        
        }
        else
        {
            self.Active.hidden = true
            if (lives>=1) {
                
                timer.invalidate()
                stopBGmusic()
                let delay = 0.5 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) {
                    if self.interstitial.isReady {
                        self.interstitial.presentFromRootViewController(self)
                    } else {
                        print("Ad wasn't ready")
                    }
                    
                }
                let current = NSUserDefaults.standardUserDefaults().valueForKey("level") as? Int ?? 10
                Flurry.logEvent("User completed level \(current)")
                self.performSegueWithIdentifier("Ok", sender: self)
            }
            else
            {
                timer.invalidate()
                stopBGmusic()
                let delay = 0.5 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) {
                    if self.interstitial.isReady {
                        self.interstitial.presentFromRootViewController(self)
                    } else {
                        print("Ad wasn't ready")
                    }
                }
                let current = NSUserDefaults.standardUserDefaults().valueForKey("level") as? Int ?? 10
                Flurry.logEvent("User failed level \(current)")
                self.performSegueWithIdentifier("Fail", sender: self)
            }

        }
        self.timer.fire()
    }

    
    
    
    
    @IBAction func AnswerSelect(sender: UIButton) {
        Answer1.enabled = false
        Answer2.enabled = false
        Answer3.enabled = false
        Answer4.enabled = false
        let buttons = [Answer1, Answer2, Answer3, Answer4]
        
        if (questions[questioNum].isGuessCorrect(sender.tag)){
            dispatch_async(dispatch_get_main_queue()){
                Chirp.sharedManager.playSound(fileName: "CorrectAnswer.mp3")
            }
            Answer1.enabled = false
            Answer2.enabled = false
            Answer3.enabled = false
            Answer4.enabled = false
            sender.setBackgroundImage(UIImage(named: "RightQuestion"), forState: .Normal)
            questioNum = Int(arc4random_uniform(UInt32(9)))
            i += 1
            let delay = 1.5 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.updateUI(self.questioNum)
            }
            
            }
        else{
            
            dispatch_async(dispatch_get_main_queue()){
                    Chirp.sharedManager.playSound(fileName: "WrongAnswer.mp3")
                }
            
            if (isCheating)
            {
                
                sender.setBackgroundImage(UIImage(named: "WrongQuestion"), forState: .Normal)
                isCheating = false
                Answer1.enabled = true
                Answer2.enabled = true
                Answer3.enabled = true
                Answer4.enabled = true
            }
            else
            {
                
                Answer1.enabled = false
                Answer2.enabled = false
                Answer3.enabled = false
                Answer4.enabled = false
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
                questioNum = Int(arc4random_uniform(UInt32(9)))
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
            questioNum = Int(arc4random_uniform(UInt32(9)))
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
        
        Flurry.logEvent("User is cheating, additional live was used")
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.playSound(fileName: "Help.mp3")
        }
        if(UseHelp()){
        sender.enabled = false
        timeCount = 11
        isCheating = true
        }
    }
    
    @IBAction func HelpCheat(sender: UIButton) {
        
        Flurry.logEvent("User is cheating, additional time was used")
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.playSound(fileName: "Help.mp3")
        }
        if(UseHelp()){
        sender.enabled = false
        timeCount += 10
        let delay = 7.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            sender.enabled = true
        }
        }
    }
    
    @IBAction func Help5050(sender: UIButton) {
        Flurry.logEvent("User is cheating, 50/50 was used")
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.playSound(fileName: "Help.mp3")
        }
        sender.enabled = false
        if(UseHelp()){
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
        
    }
    
    func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8901960017865562/4264150132")
        let request = GADRequest()
        interstitial.loadRequest(request)

    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.questions.isEmpty){
            print ("empty =(((")
            return 0
        }
        else
        {

        if (collectionView == AnswerDisplayCV) {
            return answersLetters.count
        }
        else{
            return lettersToSelect.count
        }
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if (collectionView == AnswerDisplayCV) {
            let DispCell: AnswerDisplayCell = collectionView.dequeueReusableCellWithReuseIdentifier("CellAnswer", forIndexPath: indexPath) as! AnswerDisplayCell
            DispCell.letter.text = answersLetters[indexPath.row]
        
            if(right){
                switch iscorrect {
                case "yes":
                    DispCell.i.image = UIImage(named: "letterC")
                    
                case "no":
                    DispCell.i.image = UIImage(named: "letterW")
                    
                default:
                    DispCell.i.image = UIImage(named: "letter")
                    
                }
            }
            else
            {
            if (DispCell.letter.text == "0")
            {
                DispCell.letter.text = ""
                DispCell.i.image = UIImage(named: "placeForLetter")
            }
            else
            {
                DispCell.i.image = UIImage(named: "letter")
            }
            }
            return DispCell
            
        }
        else{
            let AnswrCell: AnswerSelectCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! AnswerSelectCell
            AnswrCell.ImageToSelect.image = UIImage(named: "letter")
            AnswrCell.LetterToSelect.text = lettersToSelect[indexPath.row]
            return AnswrCell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Cell \(indexPath.row) selected")
        
        
        if (collectionView == AnswerSelectCV)
        {
            var n = 0
            let SelectedCell = AnswerSelectCV.cellForItemAtIndexPath(indexPath) as! AnswerSelectCell
            lettersToSelect.removeAtIndex(indexPath.row)
            answersLetters.removeAtIndex(answersLetters.count-1)
            answersLetters.insert(SelectedCell.LetterToSelect.text!, atIndex: self.l)
            self.l+=1
            //answersLetters.append(SelectedCell.LetterToSelect.text!)
            let string1 = self.questions[questioNum].answers[0]
            
            for i in answersLetters{
                if (i != "0")
                {
                    n+=1
                }
            }
            if (n == string1.characters.count) {
                AnswerSelectCV.hidden = true
                if (answersLetters.joinWithSeparator("") == string1.uppercaseString) {
                    dispatch_async(dispatch_get_main_queue()){
                        Chirp.sharedManager.playSound(fileName: "CorrectAnswer.mp3")
                    }
                    timeCount = 13.0
                    questioNum = Int(arc4random_uniform(UInt32(9)))
                    i += 1
                    right = true
                    iscorrect = "yes"
                    
                    let delay = 1.5 * Double(NSEC_PER_SEC)
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        self.updateUI(self.questioNum)
                        self.right = false
                        self.answersLetters = []
                        self.lettersToSelect = []
                        self.l = 0
                    }
                    
                }
                else
                {
                    if (isCheating){
                        isCheating = false
                        self.right = false
                        self.answersLetters = []
                        self.lettersToSelect = []
                        self.l = 0
                        timeCount = 13.0
                        self.lettersToSelect = (self.def.arrayForKey("lettersToSelect") as? [String])!
                        self.answersLetters = (self.def.arrayForKey("answersLetters") as? [String])!
                        self.AnswerDisplayCV.reloadData()
                        self.AnswerSelectCV.reloadData()
                        AnswerSelectCV.hidden = false
                    }
                    else
                    {
                    lives += -1
                    i += 1
                    right = true
                    iscorrect = "no"
                    questioNum = Int(arc4random_uniform(UInt32(9)))
                    let delay = 1.5 * Double(NSEC_PER_SEC)
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        self.updateUI(self.questioNum)
                        self.right = false
                        self.answersLetters = []
                        self.lettersToSelect = []
                        self.l = 0
                    }
                    }
                }
            }
            self.AnswerDisplayCV.reloadData()
            self.AnswerSelectCV.reloadData()
            
        }
        else
        {
            let removed = answersLetters.removeAtIndex(self.l-1)
            answersLetters.append("0")
            self.l += -1
            lettersToSelect.append(removed)
            
            //self.lettersToSelect = (self.def.arrayForKey("lettersToSelect") as? [String])!
            //self.answersLetters = (self.def.arrayForKey("answersLetters") as? [String])!
            self.AnswerDisplayCV.reloadData()
            self.AnswerSelectCV.reloadData()

        }
        
    }

    
    
    func randomString(length: Int) -> String {
        // whatever letters you want to possibly appear in the output (unicode handled properly by Swift)
        let letters = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"
        let n = UInt32(letters.characters.count)
        var out = ""
        for _ in 0..<length {
            let index = letters.startIndex.advancedBy(Int(arc4random_uniform(n)))
            out.append(letters[index])
        }
        return out
    }
    
    
    func UpdateHelpButtons(){
        let c = NSUserDefaults.standardUserDefaults().valueForKey("coins") as? String ?? "0"
        
        if(Int(c)<2){
            
            Help50to50.enabled = false
            helpAddTime.enabled = false
            helpCanbeWrong.enabled = false
        }
    }
    
    func UseHelp() -> Bool{
        let c = NSUserDefaults.standardUserDefaults().valueForKey("coins") as? String ?? "0"
        var b = true
        if (Int(c)>=2){
            def.setValue("\(Int(c)!-2)", forKey: "coins")
            b = true
            CoinsLabel.text = "\(def.valueForKey("coins") as? String ?? "0")"
        }
        else{
            UpdateHelpButtons()
            b = false
        }
        return b
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        var edgeInsets:CGFloat = 0.0
        if (collectionView != AnswerSelectCV)
        {
            if(!self.questions.isEmpty)
            {
            let string = self.questions[questioNum].answers[0]
            let count = string.characters.count
                switch count {
                case 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21:
                    edgeInsets = (UIScreen.mainScreen().bounds.size.width - (CGFloat(answersLetters.count) * 40) - (CGFloat(answersLetters.count) * 10)) / 2
                case 1, 2, 3, 4, 5:
                    edgeInsets = (UIScreen.mainScreen().bounds.size.width - (CGFloat(answersLetters.count) * 50) - (CGFloat(answersLetters.count) * 10)) / 2
                default:
                    edgeInsets = (UIScreen.mainScreen().bounds.size.width - (CGFloat(answersLetters.count) * 50) - (CGFloat(answersLetters.count) * 10)) / 2
                }

            }
            else
            {
            let string = "1"
            let count = string.characters.count
                switch count {
                case 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21:
                    edgeInsets = (UIScreen.mainScreen().bounds.size.width - (CGFloat(answersLetters.count) * 40) - (CGFloat(answersLetters.count) * 10)) / 2
                case 1, 2, 3, 4, 5:
                    edgeInsets = (UIScreen.mainScreen().bounds.size.width - (CGFloat(answersLetters.count) * 50) - (CGFloat(answersLetters.count) * 10)) / 2
                default:
                    edgeInsets = (UIScreen.mainScreen().bounds.size.width - (CGFloat(answersLetters.count) * 50) - (CGFloat(answersLetters.count) * 10)) / 2
                }

            }
            
        }
//        else
//        {
//        edgeInsets = (UIScreen.mainScreen().bounds.size.width - (CGFloat(answersLetters.count) * 50) - (CGFloat(answersLetters.count) * 10)) / 2
//
//        }
        return UIEdgeInsetsMake(0, edgeInsets, 0, 0);
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = CGSizeMake(50, 50)
        let string = self.questions[questioNum].answers[0]
        if(string.characters.count > 5 && collectionView == AnswerDisplayCV){
            size = CGSizeMake(40, 40)
        }
        
        return size
    }
    
    deinit {
        Chirp.sharedManager.removeSound(fileName: "WrongAnswer.mp3")
        Chirp.sharedManager.removeSound(fileName: "CorrectAnswer.mp3")
        Chirp.sharedManager.removeSound(fileName: "Help.mp3")
        Chirp.sharedManager.removeSound(fileName: "tapMenu.mp3")
    }

}
