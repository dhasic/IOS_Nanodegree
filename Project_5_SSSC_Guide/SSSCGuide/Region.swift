//
//  Region.swift
//  SSSCGuide
//
//  Created by Hasic Dalmir on 30/07/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import CoreData
import MapKit


class Region: NSManagedObject, MKAnnotation {

    convenience init(name: String, county: String, link: String, numKilometers: Int, numLifts: Int, latitude: Double, longitude: Double, id: Int, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entityForName("Region", inManagedObjectContext: context){
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.longitude = longitude
            self.latitude = latitude
            self.county = county
            self.link = link
            self.numKilometers = numKilometers
            self.numLifts = numLifts
            self.name = name
            self.id = id
        }else{
            fatalError("Unable to find Entity name!")
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude as! Double, longitude: longitude as! Double)
    }
    
    var title: String? {
        return name!
    }
    
}
