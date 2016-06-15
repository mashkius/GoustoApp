//
//  GoustoProduct.swift
//  GoustoTrialProject
//
//  Created by Mantas Laurinavicius on 10/06/16.
//  Copyright © 2016 Mashkius. All rights reserved.
//

import UIKit

class GoustoProduct: NSObject, NSCoding {
    
    //MARK: struct to avoid typo error
    struct PropertyKeys {
        static let titleKey = "title"
        static let idKey = "id"
        static let descriptionKey = "description"
        static let priceKey = "price"
        static let isForSaleKey = "isForSale"
        static let attriburesKey = "attributes"
        static let categoriesKey = "categories"
        static let imageURLKey = "imageURL"
        static let imageKey = "image"
    }
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("products")
    
    // MARK: Properties
    let title:String?
    let id:String?
    let productDescription:String?
    let price:Float?
    let isForSale:Bool?
    let attributes:[GoustoProductAttribute]?
    let categories:[GoustoCategory]?
    var imageURL:String?
    var image:UIImage?
    
    //MARK: init from raw data
    init(jsonDictionary:NSDictionary) {
        self.title = jsonDictionary["title"] as? String
        self.id = jsonDictionary["id"] as? String
        self.productDescription = jsonDictionary["description"] as? String
        self.price = Float((jsonDictionary["list_price"] as? String)!)
        self.isForSale = jsonDictionary["is_for_sale"] as? Bool
        self.attributes = [GoustoProductAttribute]()
        self.categories = [GoustoCategory]()
        if let attributesList = jsonDictionary["attributes"] as? NSArray {
            for attribute in attributesList {
                self.attributes?.append(GoustoProductAttribute(jsonDictionary:attribute as! NSDictionary))
            }
        }
        if let cat = jsonDictionary["categories"] as? NSArray {
            for category in cat {
                self.categories?.append(GoustoCategory(jsonDictionary: category as! NSDictionary))
            }
        }
        self.image = UIImage()
        self.imageURL = ""
        super.init()
        
        if let images = jsonDictionary["images"] as? NSDictionary {
            if let imageFolder = images[images.allKeys.first as! String] as? NSDictionary {
                self.imageURL = imageFolder["url"] as? String
            }
        }
    }
    
    init(title:String, id:String, isForSale:Bool, price:Float, description:String, attributes:[GoustoProductAttribute], categories:[GoustoCategory], imageURL:String, image:UIImage) {
        self.title = title
        self.id = id
        self.productDescription = description
        self.price = price
        self.isForSale = isForSale
        self.attributes = attributes
        self.categories = categories
        self.image = image
        self.imageURL = imageURL
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: PropertyKeys.titleKey)
        aCoder.encodeObject(id, forKey: PropertyKeys.idKey)
        aCoder.encodeBool(isForSale!, forKey: PropertyKeys.isForSaleKey)
        aCoder.encodeObject(productDescription, forKey: PropertyKeys.descriptionKey)
        aCoder.encodeObject(attributes, forKey: PropertyKeys.attriburesKey)
        aCoder.encodeFloat(price!, forKey: PropertyKeys.priceKey)
        aCoder.encodeObject(categories, forKey: PropertyKeys.categoriesKey)
        aCoder.encodeObject(imageURL, forKey: PropertyKeys.imageURLKey)
        if let data = UIImageJPEGRepresentation(image!,1) {
          aCoder.encodeDataObject(data)
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObjectForKey(PropertyKeys.titleKey) as! String
        let id = aDecoder.decodeObjectForKey(PropertyKeys.idKey) as! String
        let isForSale = aDecoder.decodeBoolForKey(PropertyKeys.isForSaleKey)
        let price = aDecoder.decodeFloatForKey(PropertyKeys.priceKey)
        let productDescription = aDecoder.decodeObjectForKey(PropertyKeys.descriptionKey)as! String
        let attributes = aDecoder.decodeObjectForKey(PropertyKeys.attriburesKey) as! [GoustoProductAttribute]
        let categories = aDecoder.decodeObjectForKey(PropertyKeys.categoriesKey) as! [GoustoCategory]
        let imageURL = aDecoder.decodeObjectForKey(PropertyKeys.imageURLKey) as! String
        var image = UIImage()
        if let data = aDecoder.decodeDataObject() {
           image = UIImage(data: data)!
        }
        
        self.init(title:title, id: id, isForSale: isForSale, price: price, description: productDescription, attributes:attributes, categories:categories,imageURL:imageURL,image:image)
    }
    
}
