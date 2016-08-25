//
//  EventInformationViewController.swift
//  SSSCGuide
//
//  Created by Hasic Dalmir on 30/07/16.
//  Copyright © 2016 abc. All rights reserved.
//

import UIKit
import CoreData

class EventInformationViewController: UIViewController, NSFetchedResultsControllerDelegate{
    
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var segmentsLabel: UILabel!
    @IBOutlet weak var regionsVisitedLabel: UILabel!
    @IBOutlet weak var kilometersLabel: UILabel!
    
    
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

        eventsTableView.delegate = self
        eventsTableView.dataSource = self
    }
    
    //Every time when view appears update statisctics and reload events
    override func viewWillAppear(animated: Bool) {
        
        let stack = delegate.stack

        let fr = NSFetchRequest(entityName: "Event")
        fr.sortDescriptors = [NSSortDescriptor(key: "start", ascending: true)]
        
        // Create A FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        eventsTableView.reloadData()
        updateStatistics()
    }
    
    func updateStatistics () {
        
        var reg = Set<String>()
        var kilometers = Set<Int>()
        var totalKm = 0
        
        if let objects = fetchedResultsController?.fetchedObjects {
            segmentsLabel.text = "\(fetchedResultsController!.fetchedObjects!.count)"
            for object in objects {
                let o = object as! Event
                reg.insert("\(o.inRegion!.name!)")
                kilometers.insert((Int)(o.inRegion!.numKilometers!))
            }
            
            for km in kilometers {
                totalKm = totalKm + km
            }
            
            regionsVisitedLabel.text = "\(reg.count) out 25 "
            kilometersLabel.text! = "\(totalKm) out 2.750"
            
        }
        else {
            segmentsLabel.text = "0"
            regionsVisitedLabel.text = "0"
            kilometersLabel.text = "0"
        }
    }
    
    
}

extension EventInformationViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell") as! EventCell
        let e = fetchedResultsController?.objectAtIndexPath(indexPath) as! Event
        cell.title.text = "On \(convertDate(e.start!).0) in: \(e.inRegion!.name!)"
        if e.end == nil {
            cell.subtitle.text = "From: \(convertDate(e.start!).1)  to: ..."
        }
        else {
            cell.subtitle.text = "From: \(convertDate(e.start!).1)  to: \(convertDate(e.end!).1)"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((fetchedResultsController?.fetchedObjects) != nil) {
            return fetchedResultsController!.fetchedObjects!.count
        }
        
        else {
            return 0;
        }
    }
    
    func convertDate (date: NSDate) -> (String, String) {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year, .Hour, .Minute], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minutes = components.minute
        
        return ("\(month)/\(day)/\(year)","\(hour):\(minutes)")
    }
}

