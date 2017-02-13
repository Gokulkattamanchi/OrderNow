//
//  Orders+CoreDataProperties.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 12/1/16.
//  Copyright © 2016 Monmouth University. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Orders {

    @NSManaged var orderId: NSNumber?
    @NSManaged var orderName: String?
    @NSManaged var productDetails: NSSet?

}
