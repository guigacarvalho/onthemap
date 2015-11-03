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
    
    @IBAction func logoutTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mapView.delegate = self
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

