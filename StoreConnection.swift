//
//  StoreConnection.swift
//  GoustoTrialProject
//
//  Created by Mantas Laurinavicius on 10/06/16.
//  Copyright © 2016 Mashkius. All rights reserved.
//

import UIKit

class StoreConnection: NSObject {
    
    func startWithUrlandCompletionHandler(url:NSURL, completion:(data:NSData)->Void) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data,response, error -> Void in
            if (error != nil) {
                print(error)
            } else if data != nil {
                completion(data: data!)
            }
        })
        
        task.resume()
    }
    
    deinit {
       // print("class was deallocated: %@",self)
    }
}
