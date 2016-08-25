//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Hasic Dalmir on 26/05/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    // authentication state
    var sessionID : String? = nil
    var userID : String? = nil
    
    //user info
    var firstName: String? = nil
    var lastName: String? = nil
    var mapString: String? = nil
    var mediaUrl: String? = nil
    var latutude: Double? = nil
    var longitude: Double? = nil
    var objectID: String? = nil
        
    // MARK: Initializers
    
    override init() {
        super.init()
        session.configuration.timeoutIntervalForRequest = 10;
        session.configuration.timeoutIntervalForResource = 5;
    }
    
    func authenticateWithUdacityCredentials(userName: String, password: String, completionHandlerForAuth: (success: Bool, errorString: AnyObject?) -> Void) {
        
        //1. Create a request, there are no parameters to set!
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.UdacityMethods.CreateSession)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        
        // 2. Make the request and check for errors
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                
                // handle no internet connection
                if(error!.localizedDescription == "The Internet connection appears to be offline.") {
                    completionHandlerForAuth(success: false, errorString: "The internet connection appears to be offline!" )
                    return
                }
                // handle timeout
                if(error!.localizedDescription == "The request timed out.") {
                    completionHandlerForAuth(success: false, errorString: "Poor internet connection, the request timed out!" )
                    return
                }
               
                // handle all other errors
                completionHandlerForAuth(success: false, errorString: "There was an error with your request" )
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForAuth(success: false, errorString: "Invalid Credentials" )
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandlerForAuth(success: false ,errorString: "No data was returned by the request!" )
                return
            }
            
            // 3. subset response data!
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            //4. Parse the data 
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                completionHandlerForAuth(success: false ,errorString: "Could not parse the data as JSON" )
            }
            
            //5. Extracting userID or "key"
            guard let account = parsedResult["account"] as? [String:AnyObject] else {
                completionHandlerForAuth(success: false, errorString: "Error while trying to extract session")
                return
            }
            
            guard let key = account[Constants.UdacityParameterKeys.UserID] as? String else {
               completionHandlerForAuth(success: false, errorString: "Error while trying to extract userID")
                return
            }
            
            //Storing session key and user ID
            self.userID = key
            
            //Obtain public user data, to be used later!
            self.getUserPublicData(completionHandlerForAuth)
            
        }
        task.resume()
        
    }

    func getUserPublicData(completionHandlerForStudentInfo: (success: Bool, errorString: AnyObject?) -> Void) {
        
        
        taskForGetParseMethod(subtituteKeyInMethod(Constants.UdacityMethods.GetPublicData, key: "id", value: userID!)!) { (success, error, data) in
            
            if error != nil {
                completionHandlerForStudentInfo(success: false ,errorString: error)
            }
            else {
                
                // 3. subset response data!
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                
                //4. Parse the data
                var parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                    
                } catch {
                    completionHandlerForStudentInfo(success: false ,errorString: "Could not parse the data as JSON" )
                    return
                }
                
                
                //5. Extracting user informations necessary
                //print(data)
                guard let user = parsedResult["user"] as? [String:AnyObject] else {
                    completionHandlerForStudentInfo(success: false, errorString: "Error while trying to extract user")
                    return
                }
                
                guard let fName = user[Constants.UdacityParameterKeys.FirstName] as? String else {
                    completionHandlerForStudentInfo(success: false, errorString: "Error while trying to extract first Name")
                    return
                }
                guard let lName = user[Constants.UdacityParameterKeys.LastName] as? String else {
                    completionHandlerForStudentInfo(success: false, errorString: "Error while trying to extract last Name")
                    return
                }
                
                //Storing session firstName and user lastName
                self.firstName = fName
                self.lastName = lName
                
                //Call Completion Handler
                completionHandlerForStudentInfo(success: true,errorString: nil)            }
        }
    }
    
    func logOut(completionHandlerForLogout: (success: Bool, errorString: AnyObject?) -> Void) {
        
        //1. Create a request, there are no parameters to set!
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.UdacityMethods.DeleteSession)!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        // 2. Make the request and check for errors
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                
                // handle no internet connection
                if(error!.localizedDescription == "The Internet connection appears to be offline.") {
                    completionHandlerForLogout(success: false, errorString: "The internet connection appears to be offline!" )
                    return
                }
                // handle timeout
                if(error!.localizedDescription == "The request timed out.") {
                    completionHandlerForLogout(success: false, errorString: "Poor internet connection, the request timed out!" )
                    return
                }
                
                // handle all other errors
                completionHandlerForLogout(success: false, errorString: "There was an error with your request" )
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForLogout(success: false, errorString: "Invalid Credentials" )
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandlerForLogout(success: false ,errorString: "No data was returned by the request!" )
                return
            }
            
          
            completionHandlerForLogout(success: true, errorString: nil)
            
        
        
        }
        task.resume()
        
    }

    
    

    // substitute the key for the value that is contained within the method name
    func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    
    
    
    
}