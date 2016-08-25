//
//  Event.swift
//  SSSCGuide
//
//  Created by Hasic Dalmir on 30/07/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import CoreData


class Event: NSManagedObject {

    convenience init(start: NSDate, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entityForName("Event", inManagedObjectContext: context){
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.start = start
            
        }else{
            fatalError("Unable to find Entity name!")
        }
    }
}
