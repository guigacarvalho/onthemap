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
        taskForPOSTMethod(UdacityConstants.BaseURLSecure, method: "session", parameters: parameters, jsonBody: jsonBody) { result, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                if (error.domain == "StatusCodeFailure") {
                    completionHandler(success: false, results: nil, errorString: "Are you sure yo typed the right info?")
                } else {
                    completionHandler(success: false, results: nil, errorString: "You network connection is having a hard time..")
                }
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
                    print("Could not find sessionID in \(result)")
                    completionHandler(success: false, results: nil, errorString: "Login Failed (Session ID).")
                }
            }
        }
        
    }

    func getUserInfo(completionHandler: (success: Bool, results: [String: AnyObject]?, errorString: String?) -> Void) {
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        /* 1. Specify parameters, method */
        let method = "users/" + self.appDelegate.userID
        /* 2. Make the request */
        taskForGETWithoutParamsMethod(UdacityConstants.BaseURLSecure, method: method) { result, error in

            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                if (error.domain == "StatusCodeFailure") {
                    completionHandler(success: false, results: nil, errorString: "Are you sure yo typed the right info?")
                } else {
                    completionHandler(success: false, results: nil, errorString: "You network connection is having a hard time..")
                }
            } else {
                var results : [String:AnyObject] = [
                    "first_name":"",
                    "last_name":""
                ]
                if let resultsDict = result as? [String: AnyObject] {
                    if let userDict = resultsDict["user"] as? [String: AnyObject] {
                        if let first_name = userDict["first_name"] as? String {
                            results["first_name"] = first_name
                        }
                        if let last_name = userDict["last_name"] as? String {
                            results["last_name"] = last_name
                        }
                    }
                    completionHandler(success: true, results: results, errorString: nil)
                } else {
                    print("Could not find first and last name info in \(result)")
                    completionHandler(success: false, results: nil, errorString: "Get user info failed.")
                }
            }
        }
        
    }

    
    func getSessionIDwithFB(accessToken:String, completionHandler: (success: Bool, results: [String: AnyObject]?, errorString: String?) -> Void) {
        
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let jsonBody : [String:[String:AnyObject]] = [
            "facebook_mobile": [
                "access_token": accessToken
            ]
        ]
        
        /* 2. Make the request */
        taskForPOSTMethod(UdacityConstants.BaseURLSecure, method: "session", parameters: nil, jsonBody: jsonBody) { result, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                if (error.domain == "statusCode") {
                    completionHandler(success: false, results: nil, errorString: "Are you sure yo typed the right info?")
                } else {
                    completionHandler(success: false, results: nil, errorString: "You network connection is having a hard time..")
                }
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
                    print("Could not find required info in \(result)")
                    completionHandler(success: false, results: nil, errorString: "Login Failed.")
                }
            }
        }
        
    }

    func deleteSessionID(accessToken:String, completionHandler: (success: Bool, results: [String: AnyObject]?, errorString: String?) -> Void) {
        
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        /* 2. Make the request */
        taskForDELETEMethod(UdacityConstants.BaseURLSecure, method: "session") { result, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                if (error.domain == "statusCode") {
                    completionHandler(success: false, results: nil, errorString: "Are you sure yo typed the right info?")
                } else {
                    completionHandler(success: false, results: nil, errorString: "You network connection is having a hard time..")
                }
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
                    completionHandler(success: true, results: results, errorString: nil)
                } else {
                    print("Could not find required info in \(result)")
                    completionHandler(success: false, results: nil, errorString: "Login Failed.")
                }
            }
        }
        
    }

}