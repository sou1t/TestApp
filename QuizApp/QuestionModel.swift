//
//  QuestionModel.swift
//  QuizApp
//
//  Created by Виталий Волков on 19.06.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class QuestionModel {
    var questions: Array<Question>
    //var datas: [JSON] = []
    
    
    func GetQuestions(completionHandler: ((result: JSON)->())){
        
        
        Alamofire.request(.GET, "\(ServerAdress)/getQuestions").validate().responseJSON{
            (response) in
            print(response.request?.URLString)
            let Json = JSON(response.result.value!)
            completionHandler(result: Json["response"])
            
        }
    }

    
    let ServerAdress = "http://aglinsky.ru/quiz_serv/public_html"
    init () {
        questions = []

    }
}