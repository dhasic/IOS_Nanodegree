//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Hasic Dalmir on 28/05/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet var studentsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UdacityClient.sharedInstance().getStudentLocations() { (success, errorString) in
            if success == false {
                self.displayAlert(errorString as! String)
            }
        }
    }
    
    private func displayAlert(alert: String){
        let nextConroller = UIAlertController()
        let tryAgain = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler:nil)
        nextConroller.addAction(tryAgain)
        nextConroller.title = "Registration Failed"
        nextConroller.message = alert
        self.presentViewController(nextConroller, animated: true, completion: nil)
    }


    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("studentsCell") as UITableViewCell!
        let student = StudentInformations.sharedInstance().students![indexPath.row]

        
        cell.textLabel?.text = "\(student.firstName) \(student.lastName) \(student.updatetAt)"
        cell.imageView?.image = UIImage(named: "pin")
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformations.sharedInstance().students!.count
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let app = UIApplication.sharedApplication()
        let toOpen = StudentInformations.sharedInstance().students![indexPath.row].mediaUrl

        app.openURL(NSURL(string: toOpen)!)
        
    }
    
    
    @IBAction func refreshAction(sender: AnyObject) {
        UdacityClient.sharedInstance().getStudentLocations() { (success, errorString) in
            if success {
                performUIUpdatesOnMain(){
                    self.tableView.reloadData()
                }
                
            }
            else {
                self.displayAlert(errorString as! String)
            }
        }
    
    }
    
    @IBAction func postAction(sender: AnyObject) {
        
        UdacityClient.sharedInstance().queryForAStudentLocation { (success, errorString) in
            performUIUpdatesOnMain(){
                if success != true {
                    self.displayAlert(errorString as! String)
                }
                else {
                    self.checkIfPosted();
                }
            }
        }
    }
    
    func checkIfPosted(){
        
        if UdacityClient.sharedInstance().objectID == nil {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LocationPostingViewController") as! LocationPostingViewController
            presentViewController(controller, animated: true, completion: nil)
        }
            
        else {
            let alertController = UIAlertController(title: "Post Location", message: "It seems you have already posted your location, do you want to change your location?", preferredStyle: UIAlertControllerStyle.Alert)
            
            let updateAction = UIAlertAction(title: "Update", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LocationPostingViewController") as! LocationPostingViewController
                self.presentViewController(controller, animated: true, completion: nil)
            
            })
            alertController.addAction(updateAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }

    }
    
    @IBAction func logoutAction(sender: UIBarButtonItem) {
        UdacityClient.sharedInstance().logOut { (success, errorString) in
            performUIUpdatesOnMain(){
                if success != true {
                    self.displayAlert(errorString as! String)
                }
                else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }

    
    
}