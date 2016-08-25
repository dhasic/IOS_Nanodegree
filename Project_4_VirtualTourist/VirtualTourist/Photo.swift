//
//  Photo.swift
//  VirtualTourist
//
//  Created by Hasic Dalmir on 23/07/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Photo: NSManagedObject {

 
    var task: NSURLSessionTask? = nil
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate

    convenience init(url: String, id: String, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context){
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.id = id
            self.url = url
        }else{
            fatalError("Unable to find Entity name!")
        }
    }
    
    
     // Download image in the background
    func loadImage(handler: (image : UIImage?, error: String?) -> Void) {
        
        // Check in memory
        if self.image != nil {
            let img = UIImage(data: self.image!)
            print("photo loaded from memory")
            return handler (image: img, error: nil)
        }
        
        //If not in memory, download the image and store in in persistent memory
        task = NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: NSURL(string: url!)!)) { data, response, downloadError in
            dispatch_async(dispatch_get_main_queue(), {
                guard downloadError == nil else {
                    print("Photo loading canceled")
                    return handler(image: nil, error: "Photo loadnig canceled")
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    print("Photo not loaded")
                    return handler(image: nil, error: "Photo not loaded")
                }
                
                self.image = data
                
                do{
                    try self.delegate.stack.saveContext()
                }catch{
                    print("Error while saving\(error)")
                }
                
                print("Photo loaded from internet")
                return handler(image: image, error: nil)
            })
        }
        task!.resume()
    }

}
