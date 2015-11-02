//
//  GenericConvenience.swift
//  on the map
//
//  Created by Guilherme Carvalho on 10/29/15.
//  Copyright © 2015 Guilherme Carvalho. All rights reserved.
//

import UIKit
import Foundation

// MARK: - GenericClient (Convenient Resource Methods)

extension GenericClient {
    
    func getSessionID(parameters:[String: String!], completionHandler: (success: Bool, results: [String: AnyObject]?, errorString: String?) -> Void) {
        
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let jsonBody : [String:[String:AnyObject]] = [
                    "udacity": [
                    "username": parameters["username"]!,
                    "password": parameters["password"]!
            ]
        ]

        /* 2. Make the request */
        taskForPOSTMethod("https://www.udacity.com/api/", method: "session", parameters: parameters, jsonBody: jsonBody) { result, error in

            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(success: false, results: nil, errorString: "Login Failed (Session ID). \(error)")
            } else {
                var results : [String:AnyObject] = [
                "session":"",
                "user":""
                ]
                if let resultsDict = result as? [String: AnyObject] {
                    if let sessionDict = resultsDict["session"] as? [String: AnyObject] {
                        if let sessionID = sessionDict["id"] as? String {
                            results["session"] = sessionID
                        }
                    }
                    if let accountDict = resultsDict["account"] as? [String: AnyObject] {
                        if let userID = accountDict["key"] as? String {
                            results["user"] = userID
                        }
                    }
                    completionHandler(success: true, results: results, errorString: nil)
                } else {
                    print("Could not find sessionID) in \(result)")
                    completionHandler(success: false, results: nil, errorString: "Login Failed (Session ID).")
                }
            }
        }

    }
}