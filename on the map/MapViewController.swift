//
//  MapViewController.swift
//  on the map
//
//  Created by Guilherme Carvalho on 10/27/15.
//  Copyright © 2015 Guilherme Carvalho. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    var appDelegate:AppDelegate!
    @IBOutlet weak var mapView: MKMapView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mapView.delegate = self
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        ParseClient.sharedInstance().getStudentLocations() {
            result, error in
            if let result = result {
                for student in result {
                    let studentLocation = CLLocationCoordinate2DMake(student.latitude, student.longitude)
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = studentLocation
                    dropPin.title = "\(student.firstName) \(student.lastName)"
                    dropPin.subtitle = "\(student.mediaURL)"
                    self.mapView.addAnnotation(dropPin)
                }
            }
            else {
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
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        annotationView.canShowCallout = true
        annotationView.animatesDrop = true
        annotationView.pinTintColor = UIColor.blueColor()
        
        return annotationView
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! MKPointAnnotation
        let url = NSURL(string: (annotation.subtitle)!)
        UIApplication.sharedApplication().openURL(url!)
    }

    @IBAction func postInfo(sender: AnyObject) {
        let infoPosting = self.storyboard?.instantiateViewControllerWithIdentifier("infoPostingCtrl") as! InfoPostingViewController
        self.presentViewController(infoPosting, animated: true, completion: nil)
    }
    @IBAction func logoutTapped(sender: AnyObject) {
        GenericClient.self().deleteSessionID(appDelegate.sessionID) { success, results, errorString in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }

    
    
}

