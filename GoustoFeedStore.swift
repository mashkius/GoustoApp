//
//  GoustoFeedStore.swift
//  GoustoTrialProject
//
//  Created by Mantas Laurinavicius on 10/06/16.
//  Copyright © 2016 Mashkius. All rights reserved.
//

import UIKit

let loadedDataNotificationKey = "loadedDataNotificationKey"

class GoustoFeedStore: NSObject {
    
    struct DataType {
        static let ProductType = "product"
        static let CategoryType = "category"
        static let ImageType = "image"
    }
    
    class var sharedInstance: GoustoFeedStore {
        struct Static {
            static let instance: GoustoFeedStore = GoustoFeedStore()
        }
        return Static.instance;
    }
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:nil, name: loadedDataNotificationKey, object: nil)
    }
    
    func fetchData(dataWasLoaded:Bool, completion:() -> Void) {
        // get categories
        let urlPath:String = "https://api.gousto.co.uk/products/v2.0/categories"
        
        //get products
        let screenWidth:String = String(UIScreen.mainScreen().bounds.size.width) // asking for matching screen width image
        let productsUrlPath:String = "https://api.gousto.co.uk/products/v2.0/products?includes[]=categories&includes[]=attributes&image_sizes[]=".stringByAppendingString(screenWidth)
        
        GoustoFeedStore.sharedInstance.fetchAPIFeedWithCompletion(urlPath,dataType: DataType.CategoryType) { (result) in
            if result.count > 0 {
                GoustoFeedStore.sharedInstance.fetchAPIFeedWithCompletion(productsUrlPath, dataType: DataType.ProductType) { (result) in
                    if dataWasLoaded {
                        NSNotificationCenter.defaultCenter().postNotificationName(loadedDataNotificationKey, object: nil)
                    } else {
                     completion()
                    }
                }
            }
        }
    }
    
    private func fetchAPIFeedWithCompletion(urlPath: String,dataType:String, completion:(result: [AnyObject])-> Void) {
        let url = NSURL(string: urlPath)!
        let conn: StoreConnection = StoreConnection()
        conn.startWithUrlandCompletionHandler(url) { (data) in
            if dataType==DataType.ImageType {
                let img:UIImage = UIImage.init(data: data)!
                completion(result: [img])
            } else {
                do {
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary
                    
                    var objects = self.parseDictionary(dataType, dic: jsonData)
                    if dataType == DataType.CategoryType {
                        let allCat = GoustoCategory(id: "allCategoryID", title: "All Categories")
                        objects.insert(allCat, atIndex: 0)
                        self.saveCategories(objects as! [GoustoCategory])
                        completion(result: objects)
                    } else {
                        self.downloadImagesForProduct(objects as! [GoustoProduct], completion: { (listWithImages) in
                            self.saveProducts(listWithImages)
                            completion(result: listWithImages)
                        })
                    }
                } catch {
                    print("Exception was caught while trying to serialize json!")
                }
            }
        }
    }
    
    private func parseDictionary(dataType:String,dic: NSDictionary) -> [AnyObject] {
        var goustoItems:[AnyObject] = [AnyObject]()
        if let data = dic["data"] as? NSArray {
            for item in data {
                if dataType == DataType.ProductType {
                    goustoItems.append(GoustoProduct(jsonDictionary: item as! NSDictionary))
                } else {
                    goustoItems.append(GoustoCategory(jsonDictionary: item as! NSDictionary))
                }
            }
        }
        return goustoItems
    }
    
    private func downloadImagesForProduct(list:[GoustoProduct], completion:(listWithImages:[GoustoProduct]) -> Void) {
        let group = dispatch_group_create()
        for item in list {
            if item.imageURL != "" {
                dispatch_group_enter(group)
                GoustoFeedStore.sharedInstance.fetchAPIFeedWithCompletion(item.imageURL!, dataType: DataType.ImageType) { (result) in
                    let image:UIImage = result.first as! UIImage
                    item.image = image
                    
                    dispatch_group_leave(group)
                }
            } else {
                item.image = UIImage(named: "noimagecover")
            }
        }
        
        dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            completion(listWithImages: list)
        }
    }
    
    // MARK: saving/loading data
    
    func loadCategories() -> [GoustoCategory] {
        if let data = NSKeyedUnarchiver.unarchiveObjectWithFile(GoustoCategory.ArchiveURL.path!) {
            return data as! [GoustoCategory]
        }
        //if data is nil
        return []
    }
    
    func loadProducts() -> [GoustoProduct] {
        if let data = NSKeyedUnarchiver.unarchiveObjectWithFile(GoustoProduct.ArchiveURL.path!) {
            return data as! [GoustoProduct]
        }
        
        //if data is nil
        return []
    }
    
    func saveCategories(categories:[GoustoCategory]){
        let saved = NSKeyedArchiver.archiveRootObject(categories, toFile: GoustoCategory.ArchiveURL.path!)
        if !saved {
            print("error while trying to archive categories")
        }
    }
    
    func saveProducts(products:[GoustoProduct]) {
        let saved = NSKeyedArchiver.archiveRootObject(products, toFile: GoustoProduct.ArchiveURL.path!)
        if !saved {
            print("error while trying to archive products")
        }
    }
}
