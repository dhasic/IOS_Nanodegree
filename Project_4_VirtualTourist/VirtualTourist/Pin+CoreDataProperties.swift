//
//  Pin+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Hasic Dalmir on 23/07/16.
//  Copyright © 2016 abc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pin {

    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var photos: NSSet?

}
