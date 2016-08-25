//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Hasic Dalmir on 27/05/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaUrl: String
    let uniqueKey: String
    let updatetAt: String
 
    init(dictionary: [String:AnyObject]){
        firstName = dictionary[Constants.ParseApiKeys.FirstName] as! String
        lastName = dictionary[Constants.ParseApiKeys.LastName] as! String
        latitude = dictionary[Constants.ParseApiKeys.Latitude] as! Double
        longitude = dictionary[Constants.ParseApiKeys.Longitude] as! Double
        mapString = dictionary[Constants.ParseApiKeys.MapString] as! String
        mediaUrl = dictionary[Constants.ParseApiKeys.MediaUrl] as! String
        uniqueKey = dictionary[Constants.ParseApiKeys.UniqueKey] as! String
        updatetAt = dictionary[Constants.ParseApiKeys.UpdatedAt] as! String
     }
    
    
    
    static func informationFromResults(results: [[String: AnyObject]]) -> [StudentInformation] {
        
        var studentInformations = [StudentInformation]()
        
        for result in results {
            studentInformations.append(StudentInformation(dictionary: result))
        }
        
        return studentInformations
    }
    
}