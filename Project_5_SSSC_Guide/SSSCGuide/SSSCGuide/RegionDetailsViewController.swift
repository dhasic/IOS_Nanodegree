//
//  RegionDetailsViewController.swift
//  SSSCGuide
//
//  Created by Hasic Dalmir on 31/07/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class RegionDetailsViewController: UIViewController {
    
    var region: Region?
    var annotation: MKAnnotation?
    var images: [[String:AnyObject]]?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countyLabel: UILabel!
    @IBOutlet weak var numKilometersLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var imagesFromLabel: UILabel!
    @IBOutlet weak var numLiftsLabel: UILabel!
   
    @IBAction func refreshImages(sender: UIBarButtonItem) {
        loadImages()
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        collectionView.delegate = self
        collectionView.dataSource = self
        linkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        
        updateInformationLabels()
        loadImages()
    }
    
    @IBAction func linkClicked(sender: UIButton) {
        let app = UIApplication.sharedApplication()
        
        if let toOpen = region?.link! {
            app.openURL(NSURL(string: toOpen)!)
        }
        
        
    }
    
    func updateInformationLabels() {
        nameLabel.text = region!.name!
        countyLabel.text = region!.county!
        numKilometersLabel.text = "\(region!.numKilometers!)"
        numLiftsLabel.text = "\(region!.numLifts!)"
        linkButton.setTitle("\(region!.link!)", forState: .Normal)
        imagesFromLabel.text = "Images from \(region!.name!)"
    }

    func loadImages() {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        FlickerManager.sharedInstance().searchByLatLon(annotation!.coordinate.latitude, longitude: annotation!.coordinate.longitude) { (success, errorString, data) in
            if success {
                self.images = data as! [[String:AnyObject]]
                dispatch_async(dispatch_get_main_queue()) {
                    self.collectionView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                }
            }
            else {
                self.displayAlert(errorString as! String)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
            }
        }
    }
    
    private func displayAlert(alert: String){
        let nextConroller = UIAlertController()
        let tryAgain = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler:nil)
        nextConroller.addAction(tryAgain)
        nextConroller.title = "Ooops"
        nextConroller.message = alert
        self.presentViewController(nextConroller, animated: true, completion: nil)
    }
}

extension RegionDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if images == nil {
            return 0
        }
        else {
            return 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images!.count
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let photoDictionary = images![indexPath.row] as [String:AnyObject]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionCell

        //Is there an url_m?
        guard let imageURLString = photoDictionary[Constants.FlickrResponseKeys.MediumURL] as? String else {
            self.displayAlert("No url_m found")
            return cell
        }
        
        let imageURL = NSURL(string: imageURLString)
        if let imageData = NSData(contentsOfURL: imageURL!) {
            cell.imageView.image = UIImage(data: imageData)
        }

        return cell
    }

}

