//
//  ProductsVC.swift
//  GoustoTrialProject
//
//  Created by Mantas Laurinavicius on 10/06/16.
//  Copyright © 2016 Mashkius. All rights reserved.
//

import UIKit

class ProductsVC: UITableViewController {
    
    var products:[GoustoProduct] = GoustoFeedStore.sharedInstance.loadProducts()
    var category = GoustoFeedStore.sharedInstance.loadCategories().first!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateData), name: loadedDataNotificationKey, object: nil)
        self.navigationItem.hidesBackButton = true
        self.filterProductsByCategory(self.category)
    }
    
    func filterProductsByCategory(selectedCategory:GoustoCategory) {
        category = selectedCategory
        let list = GoustoFeedStore.sharedInstance.loadProducts()
        if selectedCategory.title == "All Categories" {
            self.products = list
        } else {
            let filteredArray = list.filter { (product:GoustoProduct) -> Bool in
                return product.categories!.first?.title == selectedCategory.title
            }
            self.products = filteredArray
        }
        
        // when there are no item, tableView should notify user
        if self.products.count == 0 {
            let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            let view = UIView(frame: rect)
            view.backgroundColor = UIColor.clearColor()
            let label = UILabel(frame: rect)
            label.text = "No entries"
            label.textAlignment = .Center
            label.textColor = UIColor.lightGrayColor()
            label.font = UIFont(name: "Helvetica", size: 24)
            view.addSubview(label)
            self.tableView.backgroundView = view
        } else {
            self.tableView.backgroundView = nil
        }
        
        self.title = category.title!
        if self.isViewLoaded() && self.view.window != nil {
            self.tableView.reloadData()
        }
    }
    
    func updateData() {
        dispatch_async(dispatch_get_main_queue(), { 
            self.filterProductsByCategory(self.category)
        })
    }
    
    //MARK: tableview functions
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ProductCell = (tableView.dequeueReusableCellWithIdentifier("productCell")  as! ProductCell)
        let product:GoustoProduct = self.products[indexPath.row]
        cell.price.text = String(format: "%.2f", product.price!).stringByAppendingString("£")
        cell.titleLabel.text = product.title
        cell.imgView.image = product.image
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("productDetailsSegue", sender: self.products[indexPath.row])
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "productDetailsSegue" {
            let secondVC = segue.destinationViewController as! ProductDetailVC
            secondVC.product = sender as? GoustoProduct
        } else if segue.identifier == "categoriesSegue" {
            let modaldVC = segue.destinationViewController as! CategoriesListVC
            modaldVC.parent = self
        }
    }
    
}
