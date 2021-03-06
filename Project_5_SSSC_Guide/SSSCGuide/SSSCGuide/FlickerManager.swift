//
//  FlickerManager.swift
//  SSSCGuide
//
//  Created by Hasic Dalmir on 31/07/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FlickerManager {
    
    var fetchedResultsController : NSFetchedResultsController?
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    func searchByLatLon(latitude: Double, longitude: Double, completionHandler: (success: Bool, errorString: AnyObject?, data: AnyObject?) -> Void) {
        dispatch_async(dispatch_get_main_queue(), {
            let methodParameters: [String: String!] = [
                
                Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
                Constants.FlickrParameterKeys.SafeSearch:Constants.FlickrParameterValues.UseSafeSearch,
                Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
                Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
                Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
                Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback,
                Constants.FlickrParameterKeys.BoundingBox: self.bboxString(latitude, longitude: longitude),
                Constants.FlickrParameterKeys.PerPage: "30"
            ]
            
            self.displayImageFromFlickrBySearch(methodParameters,withRandomPageNumber: nil, completionHandler: completionHandler)
        })
        
    }
    
    
    private func bboxString(latitude: Double, longitude: Double) -> String {
        
        let minimumLon = max(longitude - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.0)
        let maximumLon = min(longitude + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.1)
        let minimumLat = max(latitude - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.0)
        let maximumLat = min(latitude + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.1)
        
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
        
    }
    
    // MARK: Flickr API
    private func displayImageFromFlickrBySearch(var methodParameters: [String:AnyObject], withRandomPageNumber: Int?, completionHandler: (success: Bool, errorString: AnyObject?, data: AnyObject?) -> Void) {
        
        
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: flickrURLFromParameters(methodParameters))
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func displayError(error:String){
                print(error)
            }
            
            guard (error == nil) else {
                completionHandler(success: false, errorString: "Error with the request", data:nil)
                return
            }
            
            //Check status code
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                completionHandler(success: false, errorString: "Status code error", data:nil)
                return
            }
            
            //Check if there is any data
            guard let data = data else {
                completionHandler(success: false, errorString: "Error with the request (data)", data:nil)
                return
            }
            
            //Parse the data
            let parsedResult: AnyObject
            do{
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            }catch{
                completionHandler(success: false, errorString: "error while parsing the result", data:nil)
                return
            }
            
            //Check if JSON returned an error
            guard let stat = parsedResult[Constants.FlickrResponseKeys.Status] as? String where stat==Constants.FlickrResponseValues.OKStatus else {
                completionHandler(success: false, errorString: "JSON returned an error", data:nil)
                return
            }
            
            
            // create photos dictionary
            guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String: AnyObject] else {
                completionHandler(success: false, errorString: "Error while creating photos dictionary", data:nil)
                return
            }
            
            //Compute random page number, less then 40 (API limit)
            if withRandomPageNumber == nil {
                guard let totalPages = photosDictionary[Constants.FlickrResponseKeys.Pages] as? Int else {
                    completionHandler(success: false, errorString: "Error on retrieving number of pages", data:nil)
                    return
                }
                
                let pageLimit = min(totalPages,40)
                let randomPageIndex = Int(arc4random_uniform(UInt32(pageLimit))) + 1
                methodParameters[Constants.FlickrParameterKeys.Page] = randomPageIndex
                self.displayImageFromFlickrBySearch(methodParameters, withRandomPageNumber:randomPageIndex, completionHandler: completionHandler)
            }
            else {
                
                //create photos array
                guard let photosArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] else {
                    completionHandler(success: false, errorString: "Error while creating phots array", data:nil)
                    return
                }
                
                //Are there any photos found?
                if photosArray.count == 0 {
                    completionHandler(success: false, errorString: "No photos found, search again!", data:nil)
                    return
                }
                
                completionHandler(success: true, errorString: nil, data: photosArray)
                
            }
            
        }
        task.resume()
    }
    
    // MARK: Helper for Creating a URL from Parameters
    private func flickrURLFromParameters(parameters: [String:AnyObject]) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.URL!
    }
    
    // Singleton
    class func sharedInstance() -> FlickerManager {
        struct Singleton {
            static var sharedInstance = FlickerManager()
        }
        return Singleton.sharedInstance
    }
    
}


