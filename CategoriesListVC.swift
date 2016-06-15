//
//  CategoriesListVC.swift
//  GoustoTrialProject
//
//  Created by Mantas Laurinavicius on 10/06/16.
//  Copyright © 2016 Mashkius. All rights reserved.
//

import UIKit

class CategoriesListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    var categories:[GoustoCategory] = [GoustoCategory]()
    var parent:ProductsVC?
    var tableView:UITableView = UITableView()
    let cellHeight:CGFloat = UIScreen.mainScreen().bounds.size.height/11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateData), name: loadedDataNotificationKey, object: nil)
        
        categories = GoustoFeedStore.sharedInstance.loadCategories()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissCategories))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        self.view.opaque = true
        self.view.backgroundColor = UIColor.clearColor()
        //some calculations to make it float in center
        self.tableView = UITableView(frame: CGRect(origin: CGPointMake(30, (self.view.frame.size.height-64)/2-(cellHeight*CGFloat(categories.count)+20)/2+64), size: CGSizeMake(self.view.frame.width-60, cellHeight*CGFloat(categories.count)+10)))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.scrollEnabled = false
        self.tableView.layer.cornerRadius = 20;
        self.tableView.layer.masksToBounds = true
        self.tableView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.tableView.layer.borderWidth = 1
        self.view.addSubview(self.tableView)
    }
    
    func updateData() {
        if self.isViewLoaded() && self.view.window != nil {
            dispatch_async(dispatch_get_main_queue(), {
                self.categories = GoustoFeedStore.sharedInstance.loadCategories()
                self.tableView.reloadData()
            })
        }
    }
    
    func dismissCategories() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view == self.view {
            return true
        } else {
            return false
        }
    }
    
    //MARK: tableview methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell()
        cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
        cell.backgroundColor = UIColor.whiteColor()
        cell.textLabel?.text = categories[indexPath.row].title
        cell.textLabel?.textAlignment = .Center
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let category:GoustoCategory = self.categories[indexPath.row]
        self.parent!.filterProductsByCategory(category)
        self.dismissCategories()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight;
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5;
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.whiteColor()
        return footer
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.whiteColor()
        return header
    }
}
