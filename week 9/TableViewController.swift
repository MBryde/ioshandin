//
//  TableViewController.swift
//  Notebook with firebase
//
//  Created by Mads Bryde on 26/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var currentNote:Note?

    override func viewDidLoad() {
        super.viewDidLoad()

        CloudStorage.startListener { (noteList) -> ([Note]) in
            self.tableView.reloadData()
            return noteList
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
            return CloudStorage.notesList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        // Sets each cell to the title of the note from our list
        cell.textLabel?.text = CloudStorage.notesList[indexPath.row].headline
        return cell
    }



    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Unpacks the id of the element to be deleted at the index of the selected row
            if let idAtIndex = CloudStorage.notesList[indexPath.row].id{

                // remove from array first so tableview knows how many rows it needs to update to
                CloudStorage.notesList.remove(at: indexPath.row)

                // Delete the row from the data source
                tableView.deleteRows(at: [indexPath], with: .fade)

                // remove from database
                CloudStorage.deleteNote(id: idAtIndex)
            }

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    // This function selects the row from the table, and saves the data in a variable. then it performs the segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentNote = CloudStorage.notesList[indexPath.row]
        //print("row id: \(indexPath.row)")

        // at the storyboard i named the segue 'showNote'
        performSegue(withIdentifier: "detailedNote", sender: self)
    }

    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DetailedViewController {
            let headline = sourceViewController.headlineText.text ?? "Headline Error."
            let text = sourceViewController.noteText.text ?? "Note Text Error."
            CloudStorage.update(id: (currentNote?.id)!, dateTime: currentNote?.dateTime ?? "10:10:10 10/10/2010", headline: headline, text: text)
            //print("\(headline) - \(text)")
        }
    }

    @IBAction func newNoteBtn(_ sender: Any) {
        CloudStorage.insertNewNote()
        // at the storyboard i named the segue 'showNote'
        performSegue(withIdentifier: "detailedNote", sender: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailedViewController {
            destination.note = currentNote
            //print("current node being sent: \(currentNote?.headline ?? "ERROR")")
            //tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
    }
}
