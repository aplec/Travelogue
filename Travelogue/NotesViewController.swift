//
//  NotesViewController.swift
//  Travelogue
//
//  Created by Ante Plecas on 5/7/20.
//  Copyright © 2020 Ante Plecas. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var notes = [Note]()
    var dateFormatter = DateFormatter()
    @IBOutlet weak var notesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchNotes()
        notesTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        if let addDate = note.addDate {
            cell.detailTextLabel?.text = dateFormatter.string(from: addDate)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            self.deleteNote(indexPath: indexPath)
        }
        
        return [deleteAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? NoteDetailTableViewController else {
            return
        }
        
        if let segueIdentifier = segue.identifier, segueIdentifier == "note", let indexPathForSelectedRow = notesTableView.indexPathForSelectedRow {
            destination.note = notes[indexPathForSelectedRow.row]
        }
    }
    
    func fetchNotes() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            notes = [Note]()
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rawAddDate", ascending: true)]
        
        do {
            notes = try managedContext.fetch(fetchRequest)
        } catch {
            alertNotifyUser(message: "Fetch for notes failed.")
        }
    }
    
    func deleteNote(indexPath: IndexPath) {
        let note = notes[indexPath.row]
        
        if let managedObjectContext = note.managedObjectContext {
            managedObjectContext.delete(note)
            
            do {
                try managedObjectContext.save()
                self.notes.remove(at: indexPath.row)
                notesTableView.reloadData()
            } catch {
                alertNotifyUser(message: "Delete failed.")
                notesTableView.reloadData()
            }
        }
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
