//
//  ProductDetails+CoreDataProperties.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 11/28/16.
//  Copyright © 2016 Monmouth University. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ProductDetails {

    @NSManaged var productName: String?
    @NSManaged var price: String?
    @NSManaged var productImageUrl: String?
    @NSManaged var productBarcodeId: String?
    @NSManaged var quantity: String?
}
