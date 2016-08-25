//
//  RegionImporter.swift
//  SSSCGuide
//
//  Created by Hasic Dalmir on 30/07/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class RegionImporter: NSObject, NSFetchedResultsControllerDelegate {
    
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
    
    func importRegions () {
        
        // Get the Stack
        let stack = delegate.stack
        
        // Create Fetch Request
        let fr = NSFetchRequest(entityName: "Region")
        fr.sortDescriptors = [NSSortDescriptor(key: "longitude", ascending: true), NSSortDescriptor(key: "latitude", ascending: false)]
        
        // Create A FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        
        let pathForAchievementsJSON = NSBundle.mainBundle().pathForResource("Regions", ofType: "json")
        let rawAchievementsJSON = NSData(contentsOfFile: pathForAchievementsJSON!)
        
        /* Parse the data into usable form */
        let parsedAchievementsJSON = try! NSJSONSerialization.JSONObjectWithData(rawAchievementsJSON!, options: .AllowFragments) as! NSDictionary
        
        guard let regions = parsedAchievementsJSON["regions"] as? [[String:AnyObject]] else {
            print("Something went wrong with dictionary construction")
            return
        }
        
        for region in regions {
            guard let name = region[Constants.RegionParameterKeys.Name] as? String else {
                print("Can not parse name")
                return
            }
            guard let county = region[Constants.RegionParameterKeys.County] as? String else {
                print("Can not parse county")
                return
            }
            guard let numKilometers = region[Constants.RegionParameterKeys.NumKilometers] as? Int else {
                print("Can not parse number of kilometers")
                return
            }
            guard let numLifts = region[Constants.RegionParameterKeys.NumLifts] as? Int else {
                print("Can not parse number of lifts")
                return
            }
            guard let link = region[Constants.RegionParameterKeys.Link] as? String else {
                print("Can not parse link")
                return
            }
            guard let latitude = region[Constants.RegionParameterKeys.Latitude] as? Double else {
                print("Can not parse latitude")
                return
            }
            guard let longitude = region[Constants.RegionParameterKeys.Longitude] as? Double else {
                print("Can not parse longitude")
                return
            }
            guard let id = region[Constants.RegionParameterKeys.Id] as? Int else {
                print("Can not parse id")
                return
            }
            let r = Region(name: name, county: county, link: link, numKilometers: numKilometers, numLifts: numLifts, latitude: latitude, longitude: longitude,id: id, context: fetchedResultsController!.managedObjectContext)
        }
        
        do{
            try delegate.stack.saveContext()
        }catch{
            print("Error while saving")
        }
        
        
        print("region number \(regions.count)")
    }
    
    class func sharedInstance() -> RegionImporter {
        struct Singleton {
            static var sharedInstance = RegionImporter()
        }
        return Singleton.sharedInstance
    }
}