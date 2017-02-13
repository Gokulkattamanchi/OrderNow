//
//  Product.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 11/28/16.
//  Copyright © 2016 Monmouth University. All rights reserved.
//

import Foundation


class Product: NSObject {
    var productName: String?
    var productPrice: String?
    var productImageUrl: String?
    var productBarcodeId: String?
    var quantity: String?
    
    init(productName: String, productPrice: String, productImageUrl: String, productBarcodeId: String, quantity: String) {
        
        self.productName = productName
        self.productPrice = productPrice
        self.productImageUrl = productImageUrl
        self.productBarcodeId = productBarcodeId
        self.quantity = quantity
    }
}