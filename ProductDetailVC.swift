//
//  ProductDetailVC.swift
//  GoustoTrialProject
//
//  Created by Mantas Laurinavicius on 11/06/16.
//  Copyright © 2016 Mashkius. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {
    
    var product:GoustoProduct?
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var details: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let price = self.product?.price {
            self.priceLabel.text = self.formatPriceToString(price)
        }
        
        self.titleLabel.text = self.product?.title
        self.details.text = self.product?.productDescription
        self.imgView.image = self.product?.image
    }
    
    func formatPriceToString(number:Float) -> String {
        return String(format: "%.2f",number).stringByAppendingString("£")
    }
}
