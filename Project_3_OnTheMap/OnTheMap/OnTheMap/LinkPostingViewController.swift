//
//  LinkPostingViewController.swift
//  OnTheMap
//
//  Created by Hasic Dalmir on 12/06/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LinkPostingViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    var coordinates: CLLocationCoordinate2D!
    var mapString: String!
    @IBOutlet weak var linkTextField: UITextView!
    @IBOutlet weak var mapOutlet: MKMapView!
    
    override func viewDidLoad() {
        print("entered link posting vc")
        print(coordinates)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = "\(UdacityClient.sharedInstance().firstName!) \(UdacityClient.sharedInstance().lastName!)"
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinates, span)
        
        self.mapOutlet.addAnnotation(annotation)
        self.mapOutlet.setRegion(region, animated: true)
        self.mapOutlet.setCenterCoordinate(coordinates, animated: false)
        linkTextField.delegate = self
    }
    
    @IBAction func submitButton(sender: UIButton) {
        UdacityClient.sharedInstance().mediaUrl = linkTextField.text
        UdacityClient.sharedInstance().longitude = coordinates.longitude
        UdacityClient.sharedInstance().latutude = coordinates.latitude
        UdacityClient.sharedInstance().mapString = mapString
        
        if(UdacityClient.sharedInstance().objectID == nil){
            UdacityClient.sharedInstance().postStudentLocation { (success, errorString) in
                performUIUpdatesOnMain(){
                    if success != true {
                        print("error")
                        self.displayAlert(errorString as! String)
                    }
                    else{
                        self.performSegueWithIdentifier("exit", sender: self)
                    }
                }
            }
        }
        else {
            print("updating student location")
            UdacityClient.sharedInstance().updateStudentLocation { (success, errorString) in
                performUIUpdatesOnMain(){
                    if success != true {
                        print("error")
                        self.displayAlert(errorString as! String)
                    }
                    else{
                        self.performSegueWithIdentifier("exit", sender: self)
                    }
                }
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

    
    @IBAction func cancelButton(sender: UIButton) {
        self.performSegueWithIdentifier("exit", sender: self)
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
    
    func textViewDidBeginEditing(textView: UITextView){
        print("here")
        linkTextField.text = ""
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
 

}