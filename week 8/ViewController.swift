//
//  ViewController.swift
//  Personal Notebook
//
//  Created by Mads Bryde on 25/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import UIKit

class Note: NSObject, NSCoding {
    var headline : String?
    var text : String?

    init(headline: String, text: String) {
        self.headline = headline
        self.text = text
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.headline, forKey:"headline")
        aCoder.encode(self.text, forKey:"text")
    }

    required init?(coder aDecoder: NSCoder) {
        self.headline = aDecoder.decodeObject(forKey:"headline") as? String
        self.text = aDecoder.decodeObject(forKey:"text") as? String
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var notesTable: UITableView!
    @IBOutlet weak var addNoteButton: UIBarButtonItem!
    var editRowIndex = -1
    var notes = [Note]()
    var saveFile = "savedNotes.temp";
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notesTable.dataSource = self
        notesTable.delegate = self
        notes = (getObject(fileName: saveFile) as? [Note])!
    }

    @IBAction func addNoteButtonPressed(_ sender: Any) {
        let newNote = Note(headline: "New Note!", text: "note.")
        notes.insert(newNote, at: 0)
        notesTable.reloadData()
        if saveObject(fileName: saveFile, object: notes) {
            print("Saved")
        } else {
            print("error in saving")
        }
    }

    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DetailedViewController {
            let headline = sourceViewController.headLineText.text ?? "Headline Error."
            let text = sourceViewController.textField.text ?? "Note Text Error."
            updateNote(headline: headline, text: text)
        }
    }

    func updateNote(headline : String, text : String) {
        if editRowIndex > -1 {
            notes[editRowIndex].headline = headline
            notes[editRowIndex].text = text
            notesTable.reloadData()
            editRowIndex = -1
            if saveObject(fileName: saveFile, object: notes) {
                print("Saved")
            } else {
                print("error in saving")
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked on row @ index: \(indexPath.row)");
        editRowIndex = indexPath.row
        performSegue(withIdentifier: "showDetails", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailedViewController {
            destination.notes = notes[(notesTable.indexPathForSelectedRow?.row)!]
            notesTable.deselectRow(at: notesTable.indexPathForSelectedRow!, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row);
        }
        tableView.reloadData();
        saveObject(fileName: saveFile, object: notes)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = notesTable.dequeueReusableCell(withIdentifier: "cell1") {
            cell.textLabel?.text = notes[indexPath.row].headline
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func getObject(fileName: String) -> Any? {

        let filePath = self.getDirectoryPath().appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: filePath)
            let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            return object
        } catch {
            print("error is: \(error.localizedDescription)")
        }
        return nil
    }

    func saveObject(fileName: String, object: Any) -> Bool {

        let filePath = self.getDirectoryPath().appendingPathComponent(fileName)
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
            try data.write(to: filePath)
            return true
        } catch {
            print("error is: \(error.localizedDescription)")
        }
        return false
    }

    func getDirectoryPath() -> URL {
        let arrayPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return arrayPaths[0]
    }

}
