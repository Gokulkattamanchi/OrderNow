//
//  createOrdersTableViewController.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 11/24/16.
//  Copyright © 2016 Monmouth University. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



class createOrdersTableViewController: UITableViewController {
    
    var orderInfo: OrderInfo?
    var productArray: [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if orderInfo?.productDetails?.count > 0 {
            self.productArray = orderInfo!.productDetails
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "free.png")!)

        }
        
        
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.productArray?.count)!
    }
    
    
}
