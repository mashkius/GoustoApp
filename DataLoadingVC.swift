//
//  DataLoadingVC.swift
//  GoustoTrialProject
//
//  Created by Mantas Laurinavicius on 11/06/16.
//  Copyright © 2016 Mashkius. All rights reserved.
//

import UIKit

class DataLoadingVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.startFetchingData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    
    func startFetchingData() {
        let savedDataIsNotNull = GoustoFeedStore.sharedInstance.loadCategories().count>0
            && GoustoFeedStore.sharedInstance.loadProducts().count>0
        self.activityIndicator.startAnimating()
        
        //check for saved data
        if savedDataIsNotNull {
            self.showProductsVC()
        }
        
        GoustoFeedStore.sharedInstance.fetchData(savedDataIsNotNull) { (completed) in
            dispatch_async(dispatch_get_main_queue(), {
                self.showProductsVC()
            })
        }
    }
    
    func showProductsVC(){
        self.activityIndicator.stopAnimating()
        self.performSegueWithIdentifier("loadedDataSegue", sender: self)
    }
}
