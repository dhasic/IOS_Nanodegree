//
//  Constants.swift
//  OnTheMap
//
//  Created by Hasic Dalmir on 26/05/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Constants

struct Constants {
    
    //MARK Udacity Methods
    struct UdacityMethods {
        static let CreateSession = "https://www.udacity.com/api/session"
        static let DeleteSession = "https://www.udacity.com/api/session"
        static let GetPublicData = "https://www.udacity.com/api/users/{id}"
    }
    
    struct UdacityParameterKeys {
        static let UserID = "key"
        static let SessionID = "id"
        static let LastName = "last_name"
        static let FirstName = "first_name"
        
    }
    
    struct ParseApi {
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    
    struct ParseApiMethods {
        static let GetStudentLocations = "https://api.parse.com/1/classes/StudentLocation"
        static let GetStudentLocationsWithLimit = "https://api.parse.com/1/classes/StudentLocation?limit={limit}&&order=-updatedAt"
        static let QueryStudentLocation = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22{id}%22%7D"
        static let postLocation = "https://api.parse.com/1/classes/StudentLocation"
        static let UpdateStudentLocation = "https://api.parse.com/1/classes/StudentLocation/{objectID}"
    }
    
    struct ParseApiKeys {
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString =  "mapString"
        static let MediaUrl = "mediaURL"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
        static let ObjectId = "objectId"
        static let Results = "results"
    }
    
    
    struct UI {
        static let LoginColorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).CGColor
        static let LoginColorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).CGColor
        static let GreyColor = UIColor(red: 0.702, green: 0.863, blue: 0.929, alpha:1.0)
        static let BlueColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    }
    
    struct Selectors {
        static let KeyboardWillShow: Selector = "keyboardWillShow:"
        static let KeyboardWillHide: Selector = "keyboardWillHide:"
        static let KeyboardDidShow: Selector = "keyboardDidShow:"
        static let KeyboardDidHide: Selector = "keyboardDidHide:"
    }
}