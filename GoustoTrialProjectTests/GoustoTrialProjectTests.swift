//
//  GoustoTrialProjectTests.swift
//  GoustoTrialProjectTests
//
//  Created by Mantas Laurinavicius on 10/06/16.
//  Copyright © 2016 Mashkius. All rights reserved.
//

import XCTest
@testable import GoustoTrialProject

class GoustoTrialProjectTests: XCTestCase {
    var vc:ProductDetailVC!
    
    override func setUp() {
        super.setUp()
        
        vc = ProductDetailVC()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testProductDetailsVC() {
        let res = vc.formatPriceToString(50.136)
        XCTAssertEqual("50.14£", res)
        XCTAssertNotEqual("50.13£", res)
    }
    
}
