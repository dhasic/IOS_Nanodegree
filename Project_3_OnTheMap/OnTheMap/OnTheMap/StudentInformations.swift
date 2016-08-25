//
//  StudentInformations.swift
//  OnTheMap
//
//  Created by Hasic Dalmir on 30/06/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation

class StudentInformations {

    var students: [StudentInformation]? = nil
    
    class func sharedInstance() -> StudentInformations {
        struct Singleton {
            static var sharedInstance = StudentInformations()
        }
        return Singleton.sharedInstance
    }

}