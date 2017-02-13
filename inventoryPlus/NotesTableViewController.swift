//
//  NotesTableViewController.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 11/29/16.
//  Copyright © 2016 Monmouth University. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    var noteStore = NoteStore()
    
    var notes: [Note] {
    get {
        return noteStore.notes
    }
    set {
        noteStore.notes = newValue
    }
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .long
        return formatter
        }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "free.png")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            let indexPath = self.tableView.indexPathForSelectedRow
            let note = notes[indexPath!.row]
            (segue.destination as! NotesDetailViewController).note = note
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Notes", style: .plain, target: nil, action: nil)
            
        } else if segue.identifier == "addNote" {
            
            let note = Note()
            let nc = segue.destination as! UINavigationController
            let dvc = nc.topViewController as! NotesDetailViewController
            dvc.note = note
            dvc.newNote = true
            dvc.completion = {
                self.notes.insert(note, at: 0)
                let first = IndexPath(item: 0, section: 0)
                self.tableView.insertRows(at: [first], with: .automatic)
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
            
            let note = notes[indexPath.row]
            
            cell.textLabel!.text = note.title
            cell.detailTextLabel!.text = dateFormatter.string(from: note.modificationDate as Date)
            return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tmpNote = notes[sourceIndexPath.row]
        notes.remove(at: sourceIndexPath.row)
        notes.insert(tmpNote, at: destinationIndexPath.row)
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}

