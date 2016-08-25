//
//  MapViewController.swift
//  SSSCGuide
//
//  Created by Hasic Dalmir on 31/07/16.
//  Copyright © 2016 abc. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var annotation: MKAnnotation!
    
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
        mapView.addAnnotations(fetchAllRegions())
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let regionDetailsVC = storyboard?.instantiateViewControllerWithIdentifier("RegionDetailsViewController") as? RegionDetailsViewController
            
            
            let request = NSFetchRequest(entityName: "Region")
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "name == %@", view.annotation!.title!!)
            
            // Create A FetchedResultsController
            let region = try! fetchedResultsController?.managedObjectContext.executeFetchRequest(request) as! [Region]

            regionDetailsVC?.region = region.first
            regionDetailsVC?.annotation = view.annotation!
            
            self.navigationController?.pushViewController(regionDetailsVC!, animated: true)

        }
    }

    
    func fetchAllRegions() -> [Region] {
        
        // Get the Stack
        let stack = delegate.stack
        // Create Fetch Request
        
        let fr = NSFetchRequest(entityName: "Region")
        fr.sortDescriptors = [NSSortDescriptor(key: "longitude", ascending: true)]
        
        // Create A FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController?.fetchedObjects as! [Region]
        
    }
    
}