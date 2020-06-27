//
//  CloudFirebase.swift
//  10_ImageCloud
//
//  Created by Mads Bryde on 26/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import Foundation
import FirebaseFirestore

class CloudFirebase {
    //static var notesList = [Note]()
    private static let db = Firestore.firestore()
    private static let collectionNotes = "notes"
    
    static func startListener(completion: @escaping ([Note]) -> ()){
        // array to hold the note objects
        var dbArray = [Note]()
        print("starting listener")
        db.collection(collectionNotes).addSnapshotListener { (snap, error ) in
            //print("yes")
            if error == nil{
                dbArray.removeAll()
                for note in snap!.documents {
                    let map = note.data()
                    
                    // if we can unwrap all the optionals then we create a new note object of the undwrapped data
                    if let dateTime = map["dateTime"] as? String,
                        let headline = map["headline"] as? String,
                        let text = map["body"] as? String,
                        let image = map["image"] as? String{
                        let newNote = Note(id: note.documentID, dateTime: dateTime, headline: headline, body: text, image: image)
                        dbArray.append(newNote)
                    //if we can't unwrap all of them, then there might be a problem with one of them, and the we create a dictionary to check which optional that is the problem
                    }else{
                        print("Error creating a new Note from Firebase:")
                        // Creating a dictionary to find which field is the problem
                        var newNoteDict:[String:String] = ["ID":note.documentID, "DateTime":"***Error fetching data***","Headline":"***Error fetching data***","Body":"***Error fetching data***","Image":"***Error fetching data***"]
                        
                        if let dateTime = map["dateTime"] as? String{
                            newNoteDict.updateValue(dateTime, forKey: "DateTime")
                        }
                        if let headline = map["headline"] as? String{
                            newNoteDict.updateValue(headline, forKey: "Headline")
                        }
                        if let body = map["body"] as? String{
                            newNoteDict.updateValue(body, forKey: "Body")
                        }
                        if let image = map["image"] as? String{
                            newNoteDict.updateValue(image, forKey: "Image")
                        }
                        // Here we print the dictionary
                        for (key, value) in newNoteDict.enumerated(){
                            print(key, value)
                        }
                    }
                }
                // completion handler to make sure that the iteration over snap.documents is done before passing the array through the function, so it can be used in the TableViewController
                completion(dbArray)
            }else{
                print("Error: \(error.debugDescription)")
            }
        }
    }
    
    static func findDateTime() -> String{
        // Creates a dateformatter and changes format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss dd/MM-yyyy"
        
        // Creates a Date object to find the date and time
        let currDate = Date.init()
        
        // Returns string representation of date and time
        return dateFormatter.string(from: currDate)
    }
    
    static func insertNewNote() {
        let documentReference = db.collection(collectionNotes).document()
        
        var mapNote = [String : String]()
        mapNote["dateTime"] = findDateTime()
        mapNote["headline"] = "New Note"
        mapNote["body"] = "text here.."
        mapNote["image"] = ""
        
        documentReference.setData(mapNote)
    }
    
    static func deleteNote(id : String) {
        let documentReference = db.collection(collectionNotes).document(id)
        documentReference.delete()
    }
    
    static func update(id: String, dateTime: String, headline: String, body: String, image: String) {
        let documentReference = db.collection(collectionNotes).document(id)
        
        var mapNote = [String : String]()
        mapNote["dateTime"] = dateTime
        mapNote["headline"] = headline
        mapNote["body"] = body
        mapNote["image"] = image
        
        documentReference.setData(mapNote)
    }
}
