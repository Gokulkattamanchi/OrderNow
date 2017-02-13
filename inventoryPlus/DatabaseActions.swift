//
//  DatabaseActions.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 11/28/16.
//  Copyright © 2016 Monmouth University. All rights reserved.
//

import UIKit
import CoreData
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


class DatabaseActions: NSObject {
    
    
    // MARK: Core Data Stack
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "inventoryPlus", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let persistentStoreCoordinator = self.persistentStoreCoordinator
        
        // Initialize Managed Object Context
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    
    lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let persistentStoreCoordinator = self.persistentStoreCoordinator
        
        // Initialize Managed Object Context
        var privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        // Configure Managed Object Context
        privateManagedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return privateManagedObjectContext
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // Initialize Persistent Store Coordinator
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        // URL Documents Directory
        let URLs = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let applicationDocumentsDirectory = URLs[(URLs.count - 1)]
        
        // URL Persistent Store
        let URLPersistentStore = applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        
        do {
            // Add Persistent Store to Persistent Store Coordinator
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: URLPersistentStore, options: nil)
            
        } catch {
            // Populate Error
            var userInfo = [String: AnyObject]()
            userInfo[NSLocalizedDescriptionKey] = "There was an error creating or loading the application's saved data." as AnyObject?
            userInfo[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data." as AnyObject?
            
            userInfo[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "com.tutsplus.Done", code: 1001, userInfo: userInfo)
            
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            
            abort()
        }
        
        return persistentStoreCoordinator
    }()
    
    
    //MARK: Saving and retrieving Order Information Data
    
    
    func saveOrderInfo(_ orderId: Int, orderName: String,completionHandler :@escaping (_ status : Bool) -> Void) {
     
        let orderInfo = NSEntityDescription.insertNewObject(forEntityName: "Orders", into: self.privateManagedObjectContext) as! Orders
        orderInfo.orderId = NSNumber(value: orderId as Int)
        orderInfo.orderName = orderName
        orderInfo.productDetails = 	Set<ProductDetails>() as NSSet?
        
        self.privateManagedObjectContext.perform { () -> Void in
            do{
                try self.privateManagedObjectContext.save()
                completionHandler(true)
            }catch{
                completionHandler(false)
                fatalError("unable to create a new order")
            }
    
        }
    }
    
    func fetchProductsInOrder(_ orderId: Int, completionHandler: (_ products: [Product], _ status: Bool) -> Void)
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Orders")
        fetchRequest.predicate = NSPredicate(format: "self.orderId == %d", orderId)
        
        
        
        do {
            let fetchedResults = try self.privateManagedObjectContext.fetch(fetchRequest)
            
            if fetchedResults.count > 0 {
                
                let orderInfo = fetchedResults.last as! Orders
                
                let productDetailsArray = orderInfo.mutableSetValue(forKey: "productDetails").allObjects as! [ProductDetails]
                var productArray = [Product]()
                for i in 0 ..< productDetailsArray.count {
                    let productDetail = productDetailsArray[i]
                    let productName = productDetail.productName
                    let price = productDetail.price
                    let imageUrl = productDetail.productImageUrl
                    let barcodeId = productDetail.productBarcodeId
                    let quantity = productDetail.quantity
                    
                    let product = Product(productName: productName!, productPrice: price!, productImageUrl: imageUrl!, productBarcodeId: barcodeId!, quantity: quantity!)
                    productArray.append(product)
                }

                completionHandler(productArray, true)
                

                
            } else {
                let productArray = [Product]()
                completionHandler(productArray, false)
                
            }
        }catch {
            fatalError("error while fetching")
        }
        
    }
    
    
    func updateProductsInOrder(_ productDetail: Product, orderId: Int , completionHandler :@escaping (_ status : Bool) -> Void) {
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Orders")
        fetchRequest.predicate = NSPredicate(format: "self.orderId == %d", orderId)
        
        do {
            let fetchedResults = try self.privateManagedObjectContext.fetch(fetchRequest)
            
            if fetchedResults.count > 0 {
                
                let orderInfo = fetchedResults.last as? Orders
                
                
                let productInformation = NSEntityDescription.insertNewObject(forEntityName: "ProductDetails", into: self.privateManagedObjectContext) as! ProductDetails
                
                productInformation.productName      = productDetail.productName
                productInformation.price            = productDetail.productPrice
                productInformation.productBarcodeId = productDetail.productBarcodeId
                productInformation.productImageUrl = productDetail.productImageUrl
                print(productDetail.quantity)
                productInformation.quantity = productDetail.quantity
                
                
                // Create Relationship
                let productDetails = orderInfo!.mutableSetValue(forKey: "productDetails")
                productDetails.add(productInformation)
                
                
                
//                orderInfo!.setValue(NSSet(object: productDetail), forKey: "productDetails")
                
                self.privateManagedObjectContext.performAndWait { () -> Void in
                    do{
                        try self.privateManagedObjectContext.save()
                        //add check
                        print("saved")
                        completionHandler(true)
                    }catch{
                        completionHandler(false)
                        fatalError("not inserted")
                    }
                }
                
            } else {
               
                completionHandler(false)
                
            }
        }catch {
            fatalError("error while fetching")
        }


        
    }
    
    func fetchOrders(_ completionHandler : @escaping (_ status : Bool, _ response : [OrderInfo]?, _ error : NSError?) -> Void) -> Void{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Orders")
        
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest : fetchRequest){
            (asynchronousFetchResult) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                let orderInfo = self.processOrdersInfo(asynchronousFetchResult)
                
                if orderInfo?.count > 0 {
                    completionHandler(true, orderInfo, nil)
                }
                else{
                    completionHandler(false, nil, nil)
                }
            })
        }
        do{
            // Execute Asynchronous Fetch Request
            _ = try managedObjectContext.execute(asyncFetchRequest)
        }
        catch{
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    
    func processOrdersInfo(_ asychronousFetchResult : NSAsynchronousFetchResult<NSFetchRequestResult>) -> [OrderInfo]? {
        
        if let results = asychronousFetchResult.finalResult{
            var orderInfoArray = [OrderInfo]()
            for orderInfoObj in results {
                if let data = orderInfoObj as? Orders {
                    

                    let productDetailsArray = data.mutableSetValue(forKey: "productDetails").allObjects as! [ProductDetails]
                    var productArray = [Product]()
                    for i in 0 ..< productDetailsArray.count {
                        let productDetail = productDetailsArray[i]
                        let productName = productDetail.productName
                        let price = productDetail.price
                        let imageUrl = productDetail.productImageUrl
                        let barcodeId = productDetail.productBarcodeId
                        let quantity = productDetail.quantity
                        
                        let product = Product(productName: productName!, productPrice: price!, productImageUrl: imageUrl!, productBarcodeId: barcodeId!, quantity: quantity!)
                        productArray.append(product)
                        
                    }
                    let orderInfo = OrderInfo(orderId: Int(data.orderId!), orderName: data.orderName!, productDetails: productArray)
                    
                    orderInfoArray.append(orderInfo)
                }
            }
            return orderInfoArray
        }
        return nil
    }
    
    
    
    
    //MARK: Saving and retrieving Product Information Data
    
    
//    func saveProductInformation(productDetail: Product, completionHandler :(status : Bool) -> Void) {
//        
//        let fetchRequest = NSFetchRequest(entityName: "ProductDetails")
//        if let productBarcodeId = productDetail.productBarcodeId {
//            fetchRequest.predicate = NSPredicate(format: "self.productBarcodeId == %@", productBarcodeId)
//        }
//        do {
//            let fetchedResults = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
//            
//            if fetchedResults.count > 0 {
//                
//            } else {
//                let productInformation = NSEntityDescription.insertNewObjectForEntityForName("ProductDetails", inManagedObjectContext: self.privateManagedObjectContext) as! ProductDetails
//                
//                productInformation.productName      = productDetail.productName
//                productInformation.price            = productDetail.productPrice
//                productInformation.productBarcodeId = productDetail.productBarcodeId
//                productInformation.productImageUrl = productDetail.productImageUrl
//
//                self.privateManagedObjectContext.performBlockAndWait { () -> Void in
//                    do{
//                        try self.privateManagedObjectContext.save()
//                        //add check
//                        print("saved")
//                        completionHandler(status: true)
//                    }catch{
//                        completionHandler(status: false)
//                        fatalError("not inserted")
//                    }
//                }
//            }
//        }catch {
//            fatalError("error while fetching")
//        }
//        
//    }
//    
//    
//  
//    
//    
//    func fetchProductDetails(completionHandler : (status : Bool, response : [Product]?, error : NSError?) -> Void) -> Void{
//        
//        let fetchRequest = NSFetchRequest(entityName: "ProductDetails")
//        
//        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest : fetchRequest){
//            (asynchronousFetchResult) -> Void in
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                
//                let productInfo = self.processProductDetails(asynchronousFetchResult)
//                
//                if productInfo?.count > 0 {
//                    completionHandler(status : true, response : productInfo, error : nil)
//                }
//                else{
//                    completionHandler(status: false, response: nil, error:nil)
//                }
//            })
//        }
//        do{
//            // Execute Asynchronous Fetch Request
//            _ = try managedObjectContext.executeRequest(asyncFetchRequest)
//        }
//        catch{
//            let fetchError = error as NSError
//            print("\(fetchError), \(fetchError.userInfo)")
//        }
//    }
//    
//    
//    func processProductDetails(asychronousFetchResult : NSAsynchronousFetchResult) -> [Product]? {
//        
//        if let results = asychronousFetchResult.finalResult{
//            var productInfoArray = [Product]()
//            for productInfoObj in results {
//                if let data = productInfoObj as? ProductDetails {
//                    
//                    
//                    let productInfo = Product(productName: data.productName!, productPrice: data.price!, productImageUrl: data.productImageUrl!, productBarcodeId: data.productBarcodeId!)
//                    
//                    productInfoArray.append(productInfo)
//                }
//            }
//            return productInfoArray
//        }
//        return nil
//    }
}
