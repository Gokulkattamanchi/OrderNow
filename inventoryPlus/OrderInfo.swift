//
//  OrderInfo.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 11/30/16.
//  Copyright © 2016 Monmouth University. All rights reserved.
//

import Foundation


class OrderInfo: NSObject {
    var orderId: Int?
    var orderName: String?
    var productDetails: [Product]?
    
    init(orderId: Int, orderName: String, productDetails: [Product]) {
        
        self.orderId = orderId
        self.orderName = orderName
        self.productDetails = productDetails

    }
}