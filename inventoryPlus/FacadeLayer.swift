//
//  FacadeLayer.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 11/28/16.
//  Copyright © 2016 Monmouth University. All rights reserved.
//

import UIKit

class FacadeLayer : NSObject {
    
    static let sharedInstance = FacadeLayer()
    var dbActions: DatabaseActions
    
    override init(){
        dbActions = DatabaseActions()
    }
    
    
    //MARK: Database Methods
    
//    func saveProductInfo(productInfo: Product, completionHandler:(status: Bool) -> Void) {
//        
//        self.dbActions.saveProductInformation(productInfo) { (status) -> Void in
//            if status {
//                print("saving product info")
//            }
//            completionHandler(status: status)
//        }
//        
//    }
//    
//    func fetchProductInfo(completionHandler: (status: Bool, result: [Product]) -> Void) {
//        
//        self.dbActions.fetchProductDetails{ (status, response, error) -> Void in
//            if status {
//                if let response = response {
//                    completionHandler(status: status, result: response)
//                }
//            }else {
//                if let response = response {
//                    completionHandler(status: status, result: response)
//                }
//            }
//        }
//    }
    
    
    
    
    
    //MARK: Orders
    
    
    func saveOrderInfo(_ orderId: Int, orderName: String, completionHandler:@escaping (_ status: Bool) -> Void) {
        
        self.dbActions.saveOrderInfo(orderId, orderName: orderName) { (status) in
            if status{
               print("Order Details Saved")
            }
            completionHandler(status)
        }
        
    }
    
    func fetchSavedOrders(_ completionHandler: @escaping (_ status: Bool, _ result: [OrderInfo]) -> Void) {
        
        self.dbActions.fetchOrders { (status, response, error) in
            if status {
                if let response = response {
                    completionHandler(status, response)
                }
            }else {
                if let response = response {
                    completionHandler(status, response)
                }
            }
        }
        
    }
    
    
    func fetchProductsInOrder(_ orderId: Int, completionHandler: @escaping (_ products: [Product], _ status: Bool) -> Void){
        self.dbActions.fetchProductsInOrder(orderId) { (products, status) in
            completionHandler(products, status)
        }
    }
    
    
    func updateProductsInOrder(_ productDetail: Product, orderId: Int , completionHandler :@escaping (_ status : Bool) -> Void) {
        
        self.dbActions.updateProductsInOrder(productDetail, orderId: orderId) { (status) in
            if status{
                print("saving product in order")
            }
            completionHandler(status)
        }
        
    }
    
    
    
    
    
}
