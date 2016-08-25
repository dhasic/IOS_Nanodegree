//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Hasic Dalmir on 27/05/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UdacityClient.sharedInstance().getStudentLocations() { (success, errorString) in
            if success {
                self.displayData();
            }
            else {
                self.displayAlert(errorString as! String)
            }
        }
    }
    
    
    private func displayAlert(alert: String){
        let nextConroller = UIAlertController()
        let tryAgain = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler:{action in
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })
        nextConroller.addAction(tryAgain)
        nextConroller.title = "Registration Failed"
        nextConroller.message = alert
        self.presentViewController(nextConroller, animated: true, completion: nil)
    }
    
    
    func displayData() {
        
        for student in StudentInformations.sharedInstance().students! {
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaUrl
            
            annotations.append(annotation)
            
            self.mapView.addAnnotations(annotations)
            
        }
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    @IBAction func refreshAction(sender: UIBarButtonItem) {
        UdacityClient.sharedInstance().getStudentLocations() { (success, errorString) in
            if success {
                performUIUpdatesOnMain(){
                    self.mapView.removeAnnotations(self.annotations)
                    self.annotations.removeAll()
                    self.self.displayData()
                }
                
            }
            else {
                self.displayAlert(errorString as! String)
            }
        }
    }
    
  
    @IBAction func postAction(sender: UIBarButtonItem) {
        
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

    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {
        
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