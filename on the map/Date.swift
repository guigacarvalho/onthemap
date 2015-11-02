//
//  Date.swift
//  on the map
//
//  Created by Guilherme Carvalho on 10/27/15.
//  Copyright © 2015 Guilherme Carvalho. All rights reserved.
//

import Foundation

class Date {
    
    class func from(year:Int, month:Int, day:Int) -> NSDate {
        let c = NSDateComponents()
        c.year = year
        c.month = month
        c.day = day
        
        let gregorian = NSCalendar(identifier:NSCalendarIdentifierGregorian)
        let date = gregorian!.dateFromComponents(c)
        return date!
    }
    
    class func parse(dateStr:String, format:String="yyyy-MM-dd'T'HH:mm:ssZ") -> NSDate {
        let dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = format
        return dateFmt.dateFromString(dateStr)!
    }
}