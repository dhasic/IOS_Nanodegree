//
//  Pin.swift
//  VirtualTourist
//
//  Created by Hasic Dalmir on 23/07/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import CoreData
import MapKit


class Pin: NSManagedObject, MKAnnotation {
    
    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context){
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.longitude = longitude
            self.latitude = latitude
        }else{
            fatalError("Unable to find Entity name!")
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude as! Double, longitude: longitude as! Double)
    }
    

}
