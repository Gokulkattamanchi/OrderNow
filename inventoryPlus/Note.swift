//
//  Note.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 11/29/16.
//  Copyright © 2016 Monmouth University. All rights reserved.
//

import UIKit

let noteContentKey = "noteContentKey"
let noteModificationDateKey = "noteModificationDateKey"

class Note: NSObject, NSCoding {
    
    var content: String {
    didSet {
        if content != oldValue {
            modificationDate = Date()
        }
    }
    }
    
    var modificationDate: Date
    
    var title: String {
    var title = content
        let start = title.startIndex
        let end = title.characters.index(of: "\n")
        if end != nil {
            title = title[start..<end!]
        }
        return title
    }
    
    // MARK: - Initialization
    
    override init() {
        content = ""
        modificationDate = Date()
    }
    
    // MARK: - NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(content, forKey:noteContentKey)
        aCoder.encode(modificationDate, forKey:noteModificationDateKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        content = aDecoder.decodeObject(forKey: noteContentKey) as! String
        modificationDate = aDecoder.decodeObject(forKey: noteModificationDateKey) as! Date
        super.init()
    }
}
