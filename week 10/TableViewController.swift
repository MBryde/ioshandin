//
//  TableViewController.swift
//  10_ImageCloud
//
//  Created by Mads Bryde on 26/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    private var noteList = [Note]()
    private var selectedNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CloudFirebase.startListener { (arrayToPass) -> () in
            self.noteList = arrayToPass
            print("count: \(self.noteList.count)")
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return noteList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Configure the cell...
        cell.textLabel?.text = noteList[indexPath.row].headline
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    @IBAction func addNewNoteButton(_ sender: Any) {
        CloudFirebase.insertNewNote()
        //performSegue(withIdentifier: "DetailedNote", sender: nil)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Unpacks the id of the element to be deleted at the index of the selected row
            if let idAtIndex = noteList[indexPath.row].id{
                
                // remove from array first so tableview knows how many rows it needs to update to
                noteList.remove(at: indexPath.row)
                
                // Delete the row from the data source
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                // remove from database
                CloudFirebase.deleteNote(id: idAtIndex)
            }

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNote = noteList[indexPath.row]
        print("didSelectRowAt: \(indexPath.row)")
        performSegue(withIdentifier: "DetailedNote", sender: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let viewController = segue.destination as? ViewController{
            if let note = selectedNote{
                viewController.note = note
            }
        }
    }
}
