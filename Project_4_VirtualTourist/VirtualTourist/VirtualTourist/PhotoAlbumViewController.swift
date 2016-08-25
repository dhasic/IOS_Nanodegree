//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Hasic Dalmir on 23/07/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var annotation: MKAnnotation!
    var pin: Pin?
    
    var insertedIndexPaths: [NSIndexPath]!
    var deletedIndexPaths: [NSIndexPath]!
    
    var fetchedResultsController : NSFetchedResultsController?{
        didSet{
            fetchedResultsController?.delegate = self
            executeSearch()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        setMapView()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if(fetchedResultsController?.fetchedObjects?.count == 0) {
            downloadFlickerImages()
        }
    }
    
    func downloadFlickerImages() {
        FlickerManager.sharedInstance().fetchedResultsController = fetchedResultsController
        FlickerManager.sharedInstance().pin = pin!
        FlickerManager.sharedInstance().searchByLatLon(annotation.coordinate.latitude, longitude: annotation.coordinate.longitude) { (success, errorString) in
            
            if(success == true) {
                do{
                    try self.delegate.stack.saveContext()
                }catch{
                    print("Error while saving\(error)")
                }
            }
            else {
                print(errorString)
            }
        }
    }
    
    @IBAction func newCollectionButtonAction(sender: UIBarButtonItem) {
        deleteCurrentPhotos()
        downloadFlickerImages()
    }
    
    func deleteCurrentPhotos() {
        let request = NSFetchRequest(entityName: "Photo")
        request.predicate = NSPredicate(format: "toPin == %@", pin!)
        
        let photos = try! fetchedResultsController?.managedObjectContext.executeFetchRequest(request) as! [Photo]
        
        for photo in photos {
            delegate.stack.context.deleteObject(photo)
        }
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.fetchedResultsController!.sections?.count ?? 0
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController!.sections![section].numberOfObjects
    }
    
    //Handle deletion
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        delegate.stack.context.deleteObject(fetchedResultsController!.objectAtIndexPath(indexPath) as! Photo)
        
        do{
            try delegate.stack.saveContext()
        }catch{
            print("Error while saving\(error)")
        }
        
        print("Photo deleted")
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let photo = fetchedResultsController!.objectAtIndexPath(indexPath) as! Photo
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionCell
        cell.photo = photo
        return cell
    }
    
    func executeSearch(){
        if let fc = fetchedResultsController{
            do{
                try fc.performFetch()
            }catch let e as NSError{
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
    
    func setMapView() {
        var region: MKCoordinateRegion
        let location: CLLocationCoordinate2D
        let span: MKCoordinateSpan
        location = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
    }
    
}

extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
    
  
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        insertedIndexPaths = []
        deletedIndexPaths = []
    }
    
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            insertedIndexPaths.append(newIndexPath!)
        case .Delete:
            deletedIndexPaths.append(indexPath!)
        default: ()
        }
    
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView.performBatchUpdates({
            for indexPath in self.insertedIndexPaths {
                self.collectionView.insertItemsAtIndexPaths([indexPath])
            }
            
            for indexPath in self.deletedIndexPaths {
                self.collectionView.deleteItemsAtIndexPaths([indexPath])
            }
            }, completion: nil)
    }
}

