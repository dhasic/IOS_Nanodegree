//
//  ParseMethods.swift
//  OnTheMap
//
//  Created by Hasic Dalmir on 27/05/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func getStudentLocations (completionHandlerForAuth: (success: Bool, errorString: AnyObject?) -> Void) {
    
        taskForGetParseMethod(subtituteKeyInMethod(Constants.ParseApiMethods.GetStudentLocationsWithLimit, key: "limit", value: "100")!) { (success, error, data) in
            
            if error != nil {
                completionHandlerForAuth(success: false ,errorString: error)
            }
            else {
                //Parse the data
                var parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                } catch {
                    completionHandlerForAuth(success: false ,errorString: "Could not parse the data as JSON" )
                    return;
                }
                //Storing downloaded student Informations
                if let results = parsedResult[Constants.ParseApiKeys.Results] as? [[String:AnyObject]] {
                    
                    StudentInformations.sharedInstance().students = StudentInformation.informationFromResults(results)
                    completionHandlerForAuth(success: true, errorString: nil)
                    
                }
                else {
                    completionHandlerForAuth(success: false,errorString: "Error on extracting Student Informations")
                }
            }
        }
    }
    
    func queryForAStudentLocation(completionHandlerForAuth: (success: Bool, errorString: AnyObject?) -> Void) {
 
        taskForGetParseMethod(subtituteKeyInMethod(Constants.ParseApiMethods.QueryStudentLocation, key: "id", value: userID!)!) { (success, error, data) in

            if error != nil {
                completionHandlerForAuth(success: false ,errorString: error)
            }
            else {
                
                //3. Parse the data
                var parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                } catch {
                    completionHandlerForAuth(success: false ,errorString: "Could not parse the data as JSON" )
                    return;
                }
                
                //Storing downloaded student Informations
                if let results = parsedResult[Constants.ParseApiKeys.Results] as? [[String:AnyObject]] {
                    
                    if(results.count > 0 ){
                        for result in results {
                        UdacityClient.sharedInstance().objectID = result[Constants.ParseApiKeys.ObjectId] as! String                         }
                    }
                    
                    completionHandlerForAuth(success: true, errorString: nil)
                    
                }
                else {
                    completionHandlerForAuth(success: false,errorString: "Error on extracting Student Informations")
                }
            }
        }
    }
    
    func postStudentLocation(completionHandlerForPost: (success: Bool, errorString: AnyObject?) -> Void) {
        
        taskForPostParseMethod("POST", method: Constants.ParseApiMethods.postLocation) { (success, error) in
            
            if (success == false){
                completionHandlerForPost(success: false, errorString: error)
            }
            else {
                completionHandlerForPost(success: true, errorString: nil)
            }
            
        }
    }
        
    func updateStudentLocation(completionHandlerForUpdate: (success: Bool, errorString: AnyObject?) -> Void) {
        
        taskForPostParseMethod("PUT", method: subtituteKeyInMethod(Constants.ParseApiMethods.UpdateStudentLocation, key: "objectID", value: objectID!)!) { (success, error) in
            
            if (success == false){
                completionHandlerForUpdate(success: false, errorString: error)
            }
            else {
                completionHandlerForUpdate(success: true, errorString: nil)
            }
            
        }
        
    }

}