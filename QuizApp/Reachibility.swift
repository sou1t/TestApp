//
//  Reachibility.swift
//  QuizApp
//
//  Created by Виталий Волков on 19.07.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import Alamofire

public class ConnectionHelper: NSObject {
    var request: Alamofire.Request?
    
    func isInternetConnected(completionHandler: Bool -> Void) {
        NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(ConnectionHelper.requestTimeout), userInfo: nil, repeats: false)
        
        request = Alamofire
            .request(
                Method.HEAD,
                "http://vk.com/"
            )
            .response { response in
                if response.3?.code == -1009 {
                    completionHandler(
                        false
                    )
                } else {
                    print(response.3?.code)
                    completionHandler(
                        true
                    )
                }
        }
    }
    
    func requestTimeout() {
        request!.cancel()
    }
}