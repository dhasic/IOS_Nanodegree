//
//  Photo+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Hasic Dalmir on 25/07/16.
//  Copyright © 2016 abc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var id: String?
    @NSManaged var image: NSData?
    @NSManaged var url: String?
    @NSManaged var toPin: Pin?

}
