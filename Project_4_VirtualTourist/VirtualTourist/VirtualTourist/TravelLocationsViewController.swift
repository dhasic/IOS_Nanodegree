//
//  TravelLocationsViewController.swift
//  VirtualTourist
//
//  Created by Hasic Dalmir on 23/07/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class TravelLocationsViewController: UIViewController , MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var regionSpan: MKCoordinateSpan?
    var sharedContext: NSManagedObjectContext!
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
 
    
    var fetchedResultsController : NSFetchedResultsController?{
        didSet{
            fetchedResultsController?.delegate = self
            executeSearch()
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        let uilgr = UILongPressGestureRecognizer(target: self, action: "addAnnotation:")
        uilgr.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(uilgr)
        
        retreiveLocationFromDefaults()
        mapView.addAnnotations(fetchAllPins())

    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("Annotation selected")

        mapView.deselectAnnotation(view.annotation!, animated: false)

        let photAlbumVC = storyboard?.instantiateViewControllerWithIdentifier("PhotoAlbumViewController") as? PhotoAlbumViewController
    
        //find the pin
        var pins: [Pin]!

        do {
            let fetchRequest = NSFetchRequest(entityName: "Pin")
            fetchRequest.fetchLimit = 1
            var subPredicates : [NSPredicate] = []
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)

            
            subPredicates.append(NSPredicate(format: "longitude = %@", argumentArray:  [view.annotation!.coordinate.longitude]))
             subPredicates.append(NSPredicate(format: "latitude = %@", argumentArray:  [view.annotation!.coordinate.latitude]))
            
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
            
            try pins = fetchedResultsController?.managedObjectContext.executeFetchRequest(fetchRequest) as! [Pin]
        } catch {
            
        }
        
        
        //Create Fetch Request for entity "Photo"
        let fr = NSFetchRequest(entityName: "Photo")
        fr.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true),
                              NSSortDescriptor(key: "image", ascending: false)]
        
        
        
        //Create the Predicate
        let p = NSPredicate(format: "toPin = %@", argumentArray: pins)
    
        //Add predicate to fetch request
        fr.predicate = p
        
    
        //Create Fetched Results Controller
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: fetchedResultsController!.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    
        //Inject into NotesVC
        photAlbumVC!.fetchedResultsController = fc
        photAlbumVC!.annotation = view.annotation!
        photAlbumVC!.pin = pins.popLast()!
   
        self.navigationController?.pushViewController(photAlbumVC!, animated: true)
    }

    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        saveLocationToDefaults()
    }
    
    
    func addAnnotation(gestureRecognizer:UIGestureRecognizer){
       
        if UIGestureRecognizerState.Began == gestureRecognizer.state {

            let touchPoint = gestureRecognizer.locationInView(mapView)
            let newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            
            let pn = Pin(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude, context: fetchedResultsController!.managedObjectContext)

            do{
                try delegate.stack.saveContext()
            }catch{
                print("Error while saving")
            }
            
            mapView.addAnnotation(pn)
        }
    }
    
    
    func fetchAllPins() -> [Pin] {

        // Get the Stack
        let stack = delegate.stack
        // Create Fetch Request
        
        let fr = NSFetchRequest(entityName: "Pin")
        fr.sortDescriptors = [NSSortDescriptor(key: "longitude", ascending: true), NSSortDescriptor(key: "latitude", ascending: false)]
        
        // Create A FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)

        return fetchedResultsController?.fetchedObjects as! [Pin]
        
    }
}


extension TravelLocationsViewController {
    
    func saveLocationToDefaults() {
        NSUserDefaults.standardUserDefaults().setDouble((mapView.region.span.latitudeDelta), forKey: "locationLatitudeSpan")
        NSUserDefaults.standardUserDefaults().setDouble((mapView.region.span.longitudeDelta), forKey: "locationLongitudeSpan")
        NSUserDefaults.standardUserDefaults().setDouble((mapView.region.center.latitude), forKey: "locationLatitude")
        NSUserDefaults.standardUserDefaults().setDouble((mapView.region.center.longitude), forKey: "locationLongitude")
    }
    
    func retreiveLocationFromDefaults() {
        var region: MKCoordinateRegion
        let location: CLLocationCoordinate2D
        let span: MKCoordinateSpan
        
        if(NSUserDefaults.standardUserDefaults().doubleForKey("locationLatitude") == 0 && NSUserDefaults.standardUserDefaults().doubleForKey("locationLongitude") == 0) {
            print("First App Launch")
            
            location = CLLocationCoordinate2D(latitude: 45, longitude: 11)
            span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
            
        }
        else {
        
        location = CLLocationCoordinate2D(latitude: NSUserDefaults.standardUserDefaults().doubleForKey("locationLatitude"), longitude: NSUserDefaults.standardUserDefaults().doubleForKey("locationLongitude"))
        
        span = MKCoordinateSpan(latitudeDelta: NSUserDefaults.standardUserDefaults().doubleForKey("locationLatitudeSpan"), longitudeDelta: NSUserDefaults.standardUserDefaults().doubleForKey("locationLongitudeSpan"))
        }
        
        region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)

    }
    
}


