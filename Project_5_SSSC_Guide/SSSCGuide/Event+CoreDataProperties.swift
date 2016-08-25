//
//  Event+CoreDataProperties.swift
//  SSSCGuide
//
//  Created by Hasic Dalmir on 30/07/16.
//  Copyright © 2016 abc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event {

    @NSManaged var start: NSDate?
    @NSManaged var end: NSDate?
    @NSManaged var inRegion: Region?

}
