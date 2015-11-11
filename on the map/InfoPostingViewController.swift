//
//  InfoPostingViewController.swift
//  onthemap
//
//  Created by Guilherme Carvalho on 11/3/15.
//  Copyright © 2015 Guilherme Carvalho. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class InfoPostingViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var mapview: MKMapView!
    let manager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    var cllocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        mapview.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        activityView.stopAnimating()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        name.text = appDelegate.first_name
        lastName.text = appDelegate.last_name
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapview.setRegion(coordinateRegion, animated: true)
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.animatesDrop = true
        annotationView.pinTintColor = UIColor.blueColor()
        return annotationView
        
    }
    
    @IBAction func updateLocationTapped(sender: AnyObject) {
        // display activity indicator
        self.activityView.startAnimating()
        
        // execute geocoding
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.location.text!) { placemarks, error in
            
            
            if let placemarks = placemarks {
                self.cllocation = (placemarks[0].location)!
                
                self.mapview.hidden = false
                let studentLocation = CLLocationCoordinate2DMake(self.cllocation.coordinate.latitude, self.cllocation.coordinate.longitude)
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = studentLocation
                self.centerMapOnLocation(self.cllocation)
                self.mapview.addAnnotation(dropPin)
            }
            if (error != nil) {
                let alertController = UIAlertController(title: "Oops..", message: "Location not found", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    dispatch_async(dispatch_get_main_queue()) {
                        alertController.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
                alertController.addAction(OKAction)
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            self.activityView.stopAnimating()
            
        }
    }

    @IBAction func openURL(sender: AnyObject) {
        if let url = self.url.text {
             if let url = NSURL(string: url) {
                if "\(url)" != "" {
                    let actualUrl = url
                    UIApplication.sharedApplication().openURL(actualUrl)
                } else {
                    let alertController = UIAlertController(title: "Oops..", message: "Please type a valid URL", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        alertController.dismissViewControllerAnimated(true, completion: nil)
                    }
                    alertController.addAction(OKAction)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func postInfo(sender: AnyObject) {
        
        // Check for updated location
        
        if self.mapview.hidden {
            let alertController = UIAlertController(title: "Oops..", message: "Please update location first", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        // post information
        let key = Int(arc4random_uniform(3456789)) + 1123455
        let info : [String:AnyObject] = [
            "uniqueKey": key,
            "firstName": name.text!,
            "lastName": lastName.text!,
            "mapString": location.text!,
            "mediaURL": url.text!,
            "latitude": self.cllocation.coordinate.latitude,
            "longitude": self.cllocation.coordinate.longitude
        ]

        
        ParseClient.sharedInstance().postStudentLocation(info) {
            result, error in
            if let result = result {
                let alertController = UIAlertController(title: "Location Posted", message: "at \(result)", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                }
                alertController.addAction(OKAction)
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alertController, animated: true, completion: nil)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            if error != nil {
                let alertController = UIAlertController(title: "Oops..", message: "Something went wrong.", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                }
                alertController.addAction(OKAction)
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            }
        }
        
    }
    }