//
//  LocationPostingViewController.swift
//  OnTheMap
//
//  Created by Hasic Dalmir on 12/06/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationPostingViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var locationTextField: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        activityIndicator.hidden = true
        
    }
    
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func submit(sender: UIButton) {
        
        let address = locationTextField.text
        let geocoder = CLGeocoder()
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                self.displayAlert("Error while trying to parse the location")
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                let linkVC = self.storyboard?.instantiateViewControllerWithIdentifier("LinkPostingViewController") as! LinkPostingViewController
                linkVC.coordinates = coordinates
                linkVC.mapString = address
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.presentViewController(linkVC, animated: true, completion: nil)
                //print(coordinates)
            }
        })
     
    }
    
    private func displayAlert(alert: String){
        let nextConroller = UIAlertController()
        
        let tryAgain = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler:{action in
            nextConroller.dismissViewControllerAnimated(true, completion: nil)
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:{action in
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })
        nextConroller.addAction(tryAgain)
        nextConroller.addAction(cancel)
        nextConroller.title = "Location Invalid"
        nextConroller.message = alert
        self.presentViewController(nextConroller, animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        print("here")
        locationTextField.text = ""
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
   
    
}
