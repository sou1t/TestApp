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
    var type: String
    var photoURL: String
    
    init(question: String,answers:Array<String>,correctAnswerIndex: Int, type: String, photoURL: String) {
        self.question = question
        self.answers = answers
        self.correctAnswerIndex = correctAnswerIndex
        self.type = type
        self.photoURL = photoURL
    }
    
    func isGuessCorrect(guessNumber: Int) -> Bool {
        return correctAnswerIndex == Int(guessNumber-1)
    }
    
}
