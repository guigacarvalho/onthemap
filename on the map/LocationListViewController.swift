//
//  ListViewController.swift
//  on the map
//
//  Created by Guilherme Carvalho on 10/27/15.
//  Copyright © 2015 Guilherme Carvalho. All rights reserved.
//

import UIKit

class LocationListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var names:[String] = []
    var locations:[String] = []
    var urls:[String] = []
    var appDelegate: AppDelegate!
    @IBOutlet weak var locationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    override func viewWillAppear(animated: Bool) {
        ParseClient.sharedInstance().getStudentLocations() {
            result, error in
            if let result = result {
                for student in result {
                    let studentLocation = "\(student.latitude), \(student.longitude)"
                    let name = "\(student.firstName) \(student.lastName)"
                    let link = "\(student.mediaURL)"
                    self.names.append(name)
                    self.locations.append(studentLocation)
                    self.urls.append(link)
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.locationsTableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = self.names[indexPath.row]
        cell.detailTextLabel?.text = self.locations[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = NSURL(string: self.urls[indexPath.row])
        if let url = url {
            UIApplication.sharedApplication().openURL(url)
        } else {
            let alertController = UIAlertController(title: "Oops..", message: "No valid url found for this student.", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
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

    @IBAction func infoPosting(sender: AnyObject) {
        let infoPosting = self.storyboard?.instantiateViewControllerWithIdentifier("infoPostingCtrl") as! InfoPostingViewController
        self.presentViewController(infoPosting, animated: true, completion: nil)
    }

}

