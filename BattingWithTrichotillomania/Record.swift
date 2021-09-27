//
//  Checkrecord.swift
//  BattingWithTrichotillomania
//
//  Created by Lucy Han on 09/14/2021.
//

import Foundation
import UIKit
import os.log

class Record: NSObject{
    
    //Mark: Properties
    
    var timestamp: NSNumber?
    // var recordImage: UIImage?
    var rating: Int?
    var recordImageUrl: String?
    
    
    init(dictionary: [String: Any]) {
        
        self.rating = dictionary["rating"] as? Int
       //  self.recordImage = dictionary["recordImage"] as? UIImage
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.recordImageUrl = dictionary["recordImageUrl"] as? String
        
    }
        
    init?(timestamp: NSNumber,recordImageUrl: String?, rating: Int){
        
        //Initialization should fail if there is no name or if the rating is negative
        if rating < 0  {
            return nil
        }
        
        
        guard recordImageUrl != nil else {
            return nil
        }
        
        // The rating must be between 0 and 5
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        
        //Initialize stored properties
        self.timestamp = timestamp
        self.recordImageUrl = recordImageUrl
        self.rating = rating
    }
    
}

