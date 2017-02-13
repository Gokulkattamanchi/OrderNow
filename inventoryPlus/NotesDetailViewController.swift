//
//  NotesDetailViewController.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 11/29/16.
//  Copyright © 2016 Monmouth University. All rights reserved.
//

import UIKit

class NotesDetailViewController: UIViewController {
    
    var note: Note?
    var completion:(() -> ())?
    var newNote = false;
    
    // MARK: - Outlets
    
    @IBOutlet weak var modificationDateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "free.png")!)

        if newNote == false {
            navigationItem.rightBarButtonItem = nil
            navigationItem.leftBarButtonItem = nil
                    }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let note = self.note {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .long
            
            modificationDateLabel.text = formatter.string(from: note.modificationDate as Date)
            contentTextView.text = note.content
        }
        
        if newNote == true {
            contentTextView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if newNote == false {
            if let note = self.note {
                if note.content != contentTextView.text {
                    note.content = contentTextView.text
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        if let note = self.note {
            note.content = contentTextView.text
        }
        
        if let completion = self.completion {
            completion()
        }
        presentingViewController!.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        presentingViewController!.dismiss(animated: true, completion: nil);
    }
}

