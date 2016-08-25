//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Hasic Dalmir on 26/05/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}