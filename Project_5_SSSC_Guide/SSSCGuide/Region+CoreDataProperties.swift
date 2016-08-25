//
//  Region+CoreDataProperties.swift
//  SSSCGuide
//
//  Created by Hasic Dalmir on 31/07/16.
//  Copyright © 2016 abc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Region {

    @NSManaged var county: String?
    @NSManaged var id: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var link: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var name: String?
    @NSManaged var numKilometers: NSNumber?
    @NSManaged var numLifts: NSNumber?

}
