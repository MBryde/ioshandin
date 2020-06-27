//
//  FirstViewController.swift
//  MyNotebook
//
//  Created by Mads Bryde on 14/02/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var tableView: UITableView!
    var theText: String = "Type in some text....";
    var textArray: [String] = [];
    var userEditing = false;
    var positionInArray = -1;
    var saveFile = "stringFile.txt";

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // textArray.append("Hello");
        // textArray.append("Their");
        tableView.dataSource = self;
        tableView.delegate = self;
        readStringFromFile(fileName: saveFile);
    }

    override func viewWillAppear(_ animated: Bool) {
        text.text = theText;
    }

    @IBAction func button(_ sender: Any) {
        theText = text.text;
        if theText.count > 0 {
            if userEditing {
                textArray[positionInArray] = theText;
            } else {
                textArray.append(theText);
            }
        } else {

        }
        userEditing = false;
        saveStringToFile(str: theText, fileName: saveFile);
        theText = "";
        tableView.reloadData();
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell1"){
            cell.textLabel?.text = textArray[indexPath.row];
            return cell;
        } else {
            return UITableViewCell();
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked on row @ index: \(indexPath.row)");
        text.text = textArray[indexPath.row];
        positionInArray = indexPath.row;
        userEditing = true;
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            textArray.remove(at: indexPath.row);
        }
        tableView.reloadData();
    }

    func readStringFromFile(fileName:String) -> String {
        let filePath = getDocumentDirectory().appendingPathComponent(fileName);
        do {
            let string = try String(contentsOf: filePath, encoding: .utf8);
            print(string);
            print("The file was found. " + fileName);
            return string;
        } catch {
            print("The file was not found. " + fileName);
        }
        return "empty";
    }

    func saveStringToFile(str:String, fileName:String){
        let filePath = getDocumentDirectory().appendingPathComponent(fileName);
        do {
            try str.write(to: filePath, atomically: true, encoding: .utf8)
            print("OK writing string \(str)")
        } catch {
            print("Error writing string \(str)")
        }
    }

    func getDocumentDirectory() -> URL{
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return documentDir[0];
    }
}
