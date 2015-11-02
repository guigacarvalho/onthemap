//
//  StudentLocation.swift
//  on the map
//
//  Created by Guilherme Carvalho on 10/27/15.
//  Copyright © 2015 Guilherme Carvalho. All rights reserved.
//
//  Based on code by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

// MARK: - StudentLocation

import Foundation

struct StudentLocation {
    
    // MARK: Properties
    
    var firstName:String = ""
    var lastName:String = ""
    var mapString:String = ""
    var mediaURL:String = ""
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    // MARK: Initializers
    
    init(dictionary: [String : AnyObject]) {

        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        mediaURL = dictionary["mediaURL"] as! String
        mapString = dictionary["mapString"] as! String
    }
    
    static func locationsFromResults(results: [[String : AnyObject]]) -> [StudentLocation] {
        var movies = [StudentLocation]()
        
        for result in results {
            movies.append(StudentLocation(dictionary: result))
        }
        
        return movies
    }
}
