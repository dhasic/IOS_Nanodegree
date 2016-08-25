//
//  Convenience.swift
//  OnTheMap
//
//  Created by Hasic Dalmir on 24/06/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func taskForGetParseMethod (method: String ,completionHandlerForGet: (success: Bool, errorString: AnyObject?, data: NSData?) -> Void)  -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: NSURL(string: method)!)
        request.addValue(Constants.ParseApi.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseApi.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
                
        // 2. Make the request and check for errors
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                
                // handle no internet connection
                if(error!.localizedDescription == "The Internet connection appears to be offline.") {
                    completionHandlerForGet(success: false, errorString: "The internet connection appears to be offline!", data: nil)
                    return
                }
                // handle timeout
                if(error!.localizedDescription == "The request timed out.") {
                    completionHandlerForGet(success: false, errorString: "Poor internet connection, the request timed out!", data: nil)
                    return
                }
                
                // handle all other errors
                completionHandlerForGet(success: false, errorString: "There was an error with your request", data: nil)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            //TODO check for specific http code for authentication failed (403 or something)
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForGet(success: false, errorString: "Bad resonse", data: nil)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandlerForGet(success: false ,errorString: "No data was returned by the request!", data: nil)
                return
            }
            
            completionHandlerForGet(success: true, errorString: nil, data: data)

        }
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func taskForPostParseMethod (httpMethod: String, method: String, completionHandlerForPost: (success: Bool, errorString: AnyObject?) -> Void)  -> NSURLSessionDataTask  {
       
        //1. Create a request, there are no parameters to set!
        
        let request = NSMutableURLRequest(URL: NSURL(string: method)!)
        
        request.HTTPMethod = httpMethod
        request.addValue(Constants.ParseApi.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseApi.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"uniqueKey\": \"\(UdacityClient.sharedInstance().userID!)\", \"firstName\": \"\(UdacityClient.sharedInstance().firstName!)\", \"lastName\": \"\(UdacityClient.sharedInstance().lastName!)\",\"mapString\": \"\(UdacityClient.sharedInstance().mapString!)\", \"mediaURL\": \"\(UdacityClient.sharedInstance().mediaUrl!)\",\"latitude\": \(UdacityClient.sharedInstance().latutude!), \"longitude\": \(UdacityClient.sharedInstance().longitude!)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        
        // 2. Make the request and check for errors
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                
                // handle no internet connection
                if(error!.localizedDescription == "The Internet connection appears to be offline.") {
                    completionHandlerForPost(success: false, errorString: "The internet connection appears to be offline!")
                    return
                }
                // handle timeout
                if(error!.localizedDescription == "The request timed out.") {
                    completionHandlerForPost(success: false, errorString: "Poor internet connection, the request timed out!")
                    return
                }
                
                // handle all other errors
                completionHandlerForPost(success: false, errorString: "There was an error with your request" )
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            //TODO check for specific http code for authentication failed (403 or something)
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForPost(success: false, errorString: "Bad resonse" )
                return
            }
            
            completionHandlerForPost(success: true,errorString: nil)
            
            
        }
        task.resume()
        return task;

    }
    
}