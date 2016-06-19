//
//  Question.swift
//  QuizApp
//
//  Created by Виталий Волков on 19.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import Foundation

class Question {
    var question: String
    var answers: Array<String>
    var correctAnswerIndex: Int
    
    init(question: String,answers:Array<String>,correctAnswerIndex: Int) {
        self.question = question
        self.answers = answers
        self.correctAnswerIndex = correctAnswerIndex
    }
    
    func isGuessCorrect(guessNumber: Int) -> Bool {
        return correctAnswerIndex == Int(guessNumber-1)
    }
    
        
    
    
    
}
