//
//  OrdersViewController.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 12/1/16.
//  Copyright © 2016 Monmouth University. All rights reserved.
//

import UIKit



class OrdersViewController: UIViewController {
    
    @IBOutlet weak var ordersTableView: UITableView!
    
    var orderArray: [OrderInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.view.backgroundColor = UIColor(patternImage: UIImage(named: "free.png")!)
        self.ordersTableView.backgroundColor = UIColor.clear
        //self.tabBarController!.tabBar.barTintColor = UIColor.init(red: 191/255.0, green: 226/255.0, blue: 222/255.0, alpha: 1.0)
        self.tabBarController!.tabBar.isTranslucent = false;
     //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "free.png")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getSavedOrders()
        
    }
    
    
    func getSavedOrders() {
        
        FacadeLayer.sharedInstance.fetchSavedOrders { (status, result) in
            
            if result.count > 0 {
                if let ordersArray = result as? [OrderInfo] {
                    self.orderArray = ordersArray
                    self.ordersTableView.delegate = self
                    self.ordersTableView.dataSource = self
                    self.ordersTableView.reloadData()
                }

                
            }
        }
        
    }
    
    
}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.orderArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell", for: indexPath) as! OrdersTableViewCell
        let orderInfo = self.orderArray![indexPath.row]
        cell.orderNamelbl?.text = orderInfo.orderName
        //cell.quantityOrders?.text = orderInfo.
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderInfo = self.orderArray![indexPath.row]
        
        let productDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        productDetailsVC.orderInfo = orderInfo
        self.navigationController?.pushViewController(productDetailsVC, animated: true)

        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
}
