//
//  InfoPostingViewController.swift
//  onthemap
//
//  Created by Guilherme Carvalho on 11/3/15.
//  Copyright © 2015 Guilherme Carvalho. All rights reserved.
//

import UIKit
import MapKit


class InfoPostingViewController: UIViewController {
    
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var name: UITextField!
        @IBOutlet weak var location: UITextField!
    @IBOutlet weak var mapview: MKMapView!

    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func postInfo(sender: AnyObject) {
//        display activity indicator
        
        
        
//        execute geocoding
        
        
        
        
//        post information
        ParseClient.sharedInstance().getStudentLocations() {
            result, error in
            if let result = result {
                for student in result {
                    let studentLocation = CLLocationCoordinate2DMake(student.latitude, student.longitude)
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = studentLocation
                    dropPin.title = "\(student.firstName) \(student.lastName)"
                    dropPin.subtitle = "\(student.mediaURL)"
                    self.mapview.addAnnotation(dropPin)
                }
            }
        }
        
    }
}