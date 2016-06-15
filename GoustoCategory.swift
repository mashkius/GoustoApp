//
//  GoustoCategory.swift
//  GoustoTrialProject
//
//  Created by Mantas Laurinavicius on 10/06/16.
//  Copyright © 2016 Mashkius. All rights reserved.
//

import UIKit

class GoustoCategory: NSObject, NSCoding {
    
    struct PropertyKeys {
        static let titleKey = "title"
        static let idKey = "id"
    }
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("categories")

    let title:String?
    let id:String?
    
    init(id:String,title:String) {
        self.title = title
        self.id = id
        super.init()
    }
    
    //MARK: init from raw data
    init(jsonDictionary:NSDictionary) {
        self.title = jsonDictionary["title"] as? String
        self.id = jsonDictionary["id"] as? String
        super.init()
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: PropertyKeys.titleKey)
        aCoder.encodeObject(id, forKey: PropertyKeys.idKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObjectForKey(PropertyKeys.titleKey) as! String
        let id = aDecoder.decodeObjectForKey(PropertyKeys.idKey) as! String
        
        self.init(id:id, title: title)
    }
}
