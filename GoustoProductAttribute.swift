//
//  GoustoProductAttribute.swift
//  GoustoTrialProject
//
//  Created by Mantas Laurinavicius on 11/06/16.
//  Copyright © 2016 Mashkius. All rights reserved.
//

import UIKit

class GoustoProductAttribute: NSObject, NSCoding {
    
    struct PropertyKeys {
        static let titleKey = "title"
        static let idKey = "id"
        static let unitKey = "unit"
        static let valueKey = "value"
    }
    
    //MARK:Properties
    let id:String?
    let title:String?
    let unit:String?
    let value:String?
    
    init(id:String,title:String,unit:String,value:String) {
        self.title = title
        self.id = id
        self.unit = unit
        self.value = value
        super.init()
    }
    
    //MARK: init from raw data
    init(jsonDictionary:NSDictionary) {
        self.title = jsonDictionary["title"] as? String
        self.id = jsonDictionary["id"] as? String
        
        // I think this should be resolved in api - other objects,when not initiliazed, are nil - not NSNull object
        if (jsonDictionary["unit"] as? NSNull) == nil {
            self.unit = jsonDictionary["unit"] as? String
        } else {
            self.unit = ""
        }
        
        self.value = jsonDictionary["value"] as? String
        super.init()
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: PropertyKeys.titleKey)
        aCoder.encodeObject(id, forKey: PropertyKeys.idKey)
        aCoder.encodeObject(unit, forKey: PropertyKeys.unitKey)
        aCoder.encodeObject(value, forKey: PropertyKeys.valueKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObjectForKey(PropertyKeys.titleKey) as! String
        let id = aDecoder.decodeObjectForKey(PropertyKeys.idKey) as! String
        let unit = aDecoder.decodeObjectForKey(PropertyKeys.unitKey) as! String
        let value = aDecoder.decodeObjectForKey(PropertyKeys.valueKey) as! String
        
        self.init(id: id, title: title, unit: unit, value:value)
    }

    
}
