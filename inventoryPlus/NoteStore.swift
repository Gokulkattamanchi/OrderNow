//
//  NoteStore.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 11/29/16.
//  Copyright © 2016 Monmouth University. All rights reserved.
//

import UIKit

let noteStoreSaveFile = "notes.data"

class NoteStore: NSObject {
    
    var notes = [Note]()
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        
        let notesData = try? Data(contentsOf: savePath())
        if (notesData != nil) {
            notes = NSKeyedUnarchiver.unarchiveObject(with: notesData!) as! [Note]
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(NoteStore.save), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: -
    
    func savePath() -> URL {
        let fileManager = FileManager.default
        let documentsDirectory = try? fileManager.url(for: .documentDirectory, in:.userDomainMask, appropriateFor: nil, create: false)
        let path = documentsDirectory!.appendingPathComponent(noteStoreSaveFile)
        return path
    }
    
    func save() {
        let data = NSKeyedArchiver.archivedData(withRootObject: notes)
        try? data.write(to: savePath(), options: [.atomic])
    }
}
