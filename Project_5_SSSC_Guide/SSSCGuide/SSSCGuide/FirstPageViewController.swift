//
//  FirstPageViewController.swift
//  SSSCGuide
//
//  Created by Hasic Dalmir on 30/07/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FirstPageViewController: UIViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate {
   
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var regionField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var regions: [String] = []
    var e: Event?
    
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
        setRegionNames()
        initializeRegionField()
        setButton()
        loadLastEvent()
    }
    
    func initializeRegionField() {
        regionField.delegate = self
        var regionPickerView: UIPickerView
        regionPickerView = UIPickerView(frame: CGRectMake(0, 200, view.frame.width, 300))
        regionPickerView.backgroundColor = .whiteColor()
        regionPickerView.dataSource = self
        regionPickerView.delegate = self
        regionField.inputView = regionPickerView
        regionField.text = regions[delegate.chosenRegion]
    }
    
    @IBAction func checkInButton(sender: UIButton) {
        if (delegate.hasCheckedIn == false) {
            delegate.hasCheckedIn = true
            createEvent()
        } else {
            delegate.hasCheckedIn = false
            completeEvent()
        }
        setButton()
    }

    @IBAction func cancelCheckIn(sender: UIBarButtonItem) {
        delegate.hasCheckedIn = false
        delegate.chosenRegion = 0
        setButton()
        regionField.text = regions[0]
        cancelEvent()
    }
    
    func setButton() {
        
        if(delegate.hasCheckedIn == false) {
            checkInButton.setTitle("Check In", forState: .Normal)
            checkInButton.backgroundColor = UIColor(hex: Constants.ButtonColors.CheckInColor)
            regionField.enabled = true
            cancelButton.enabled = false
            cancelButton.tintColor = UIColor.blueColor()
        }
        else {
            checkInButton.setTitle("Check Out", forState: .Normal)
            checkInButton.backgroundColor = UIColor(hex: Constants.ButtonColors.CheckOutColor)
            regionField.enabled = false
            cancelButton.tintColor = UIColor.redColor()
            cancelButton.enabled = true
        }
        
        if delegate.chosenRegion == 0 {
            checkInButton.enabled = false

        }
        else {
            checkInButton.enabled = true
        }

    }
    
    func loadLastEvent() {
        
        // Create Fetch Request
        let request = NSFetchRequest(entityName: "Event")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "end == nil")
        
        // Create A FetchedResultsController
        let event = try! fetchedResultsController?.managedObjectContext.executeFetchRequest(request) as! [Event]
        
        e = event.first
    }
    
    func setRegionNames() {
        
        let stack = delegate.stack
        
        let fr = NSFetchRequest(entityName: "Region")
        fr.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        print(fetchedResultsController?.fetchedObjects?.count)
        
        regions.append("None")
        for object in fetchedResultsController!.fetchedObjects!{
            let o = object as! Region
            regions.append(o.name!)
        }

    }
    
    func createEvent () {

        let stack = delegate.stack

        //Find Region
        let request = NSFetchRequest(entityName: "Region")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "name == %@", regions[delegate.chosenRegion])
        
        let region = try! fetchedResultsController?.managedObjectContext.executeFetchRequest(request) as! [Region]
        
        
        //Create Event
        let fr = NSFetchRequest(entityName: "Event")
        fr.sortDescriptors = [NSSortDescriptor(key: "start", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        print(fetchedResultsController?.fetchedObjects?.count)
        e = Event(start: NSDate(), context: fetchedResultsController!.managedObjectContext)
        e?.inRegion = region.first!
        
        //Store event
        do{
            try delegate.stack.saveContext()
        }catch{
            print("Error while saving")
        }
        

    }
    
    func completeEvent () {
        e?.end = NSDate()
        
        do{
            try delegate.stack.saveContext()
        }catch{
            print("Error while saving")
        }
        
    }
    
    func cancelEvent() {
        delegate.stack.context.deleteObject(e!)
        
        do{
            try delegate.stack.saveContext()
        }catch{
            print("Error while saving")
        }
        
    }
    
}

extension FirstPageViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return regions.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        regionField.text = regions[row]
        regionField.resignFirstResponder()
        delegate.chosenRegion = row
        if(row == 0) {
            checkInButton.enabled = false
        }
        else {
            checkInButton.enabled = true
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return regions[row]
    }
    
}

extension UIColor {
    
    convenience init(hex: Int) {
        
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
        
    }
    
}