//
//  CloudFirestore.swift
//  11_CustomTables
//
//  Created by Mads Bryde on 27/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import Foundation
import FirebaseFirestore

class CloudFirebase{
    
    private static let db = Firestore.firestore()
    
    // let declarations used in the listeners
    private static let notesCollection = "notes"
    private static let orderBy = "body"
    private static let limit = 2
    
    // listener is initialized to the start listener
    static var listener = db.collection(notesCollection).order(by: orderBy).limit(to: limit)
    
    // last snapShot is used to determine where the next query should start from
    static var lastSnapshot : QueryDocumentSnapshot?
    

    // listens for changes and updates if changes are made to db
    // uses a completionhandler to make sure that the for loop is finished iterating through snap.documents
    // The first parameter ([Note]) is used to declare which type of object we we wan't to pass through the function in the parameter completion when we are finished iterating
        static func startListener(first : Bool, completion: @escaping ([Note]) -> ()){
        
            // if it's not the first time we are making a snapshot, we change the listener to start from the last snapshot and continue with two more
        if !first{
            if let lastSnapshot = lastSnapshot{
                listener = db.collection(notesCollection).order(by: orderBy).start(afterDocument: lastSnapshot).limit(to:limit)
            }
        }
        
        // array to hold the note objects
        var dbList = [Note]()
        print("starting listener")
    
        listener.addSnapshotListener { (snap, error ) in
            print("yes")
            lastSnapshot = snap!.documents.last
            if error == nil{
                dbList.removeAll()
                for note in snap!.documents {
                    let map = note.data()
                    // if we can unwrap all the optionals then we create a new note object of the unwrapped data
                    if let dateTime = map["dateTime"] as? String,
                        let title = map["headline"] as? String,
                        let text = map["body"] as? String,
                        let image = map["image"] as? String{
                        let newNote = Note(id: note.documentID, dateTime: dateTime, title: title, body: text, image: image)
                        
                        dbList.append(newNote)
                    //if we can't unwrap all of them, then there might be a problem with one of them, and the we create a dictionary to check which optional that is the problem
                    }else{
                        print("Error creating a new Note from Firebase:")
                        // Creating a dictionary to find which field is the problem
                        var newNoteDict:[String:String] = ["ID":note.documentID, "DateTime":"***Error fetching data***","Headline":"***Error fetching data***","Body":"***Error fetching data***","Image":"***Error fetching data***"]
                        
                        if let dateTime = map["dateTime"] as? String{
                            newNoteDict.updateValue(dateTime, forKey: "DateTime")
                        }
                        if let title = map["headline"] as? String{
                            newNoteDict.updateValue(title, forKey: "Headline")
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
                completion(dbList)
            }else{
                print("Error: \(error.debugDescription)")
            }
        }
    }
    
    // Date and time function
    static func findDateTime() -> String{
        // Creates a dateformatter and changes format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss dd/MM-yyyy"
        
        // Creates a Date object to find the date and time
        let currDate = Date.init()
        
        // Returns string representation of date and time
        return dateFormatter.string(from: currDate)
    }
    
    static func insertNote() -> Note{
        let docRef = db.collection(notesCollection).document()

        let note = Note(id: docRef.documentID)
        var map = [String:String]()
        map["headline"] = note.title
        map["dateTime"] = note.dateTime
        map["body"] = note.body
        map["image"] = note.image
        
        docRef.setData(map)
        
        return note
    }
    
    static func delete(id:String){
        // if you pass something in document parameter you will get that, if you doesn't pass anything (or a wrong id) it will get an empty
        let docRef = db.collection(notesCollection).document(id)
        docRef.delete()
    }
    
    static func update(note: Note){
         if let id = note.id, let dateTime = note.dateTime, let title = note.title, let body = note.body, let image = note.image{
                let docRef = db.collection(notesCollection).document(id)
                print("docID fra update: \(docRef.documentID)")
                
                var map = [String:String]()
                map["dateTime"] = dateTime
                map["title"] = title
                map["body"] = body
                map["image"] = image
        
                docRef.setData(map)
            print("updated")
        }
    }
}
