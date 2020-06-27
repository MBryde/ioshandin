//
//  CloudStorage.swift
//  11_CustomTables
//
//  Created by Mads Bryde on 27/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import Foundation
import FirebaseStorage

class CloudStorage {

    private static let storage = Storage.storage() // get the instance

    static func downloadImage(name:String, note:Note, table:UITableView){
        let imgRef = storage.reference(withPath: name) // get file handle
        // maxSixe = how big of an image should a user could download
        // makes sure that the file is downloaded before moving going in the "function"
        imgRef.getData(maxSize: 4000000){ (data, error) in
            if error == nil{
                print("success in dowloading img: \(name)")
                
                let img = UIImage(data: data!)
                
                DispatchQueue.main.async { // prevent background thread from interrupting the main thread, which handles user input
                    note.uiimage = img
                    table.reloadData()
                }
            }else{
                print("Error: \(error.debugDescription)")
            }
        }
    }
    
    static func downloadImageFULL(name:String, note:Note, completion: @escaping () -> ()){
        let imgRef = storage.reference(withPath: name) // get file handle
        // maxSixe = how big of an image should a user could download
        // makes sure that the file is downloaded before moving going in the "function"
        imgRef.getData(maxSize: 4000000){ (data, error) in
            if error == nil{
                print("success in dowloading img: \(name)")
                
                let img = UIImage(data: data!)
                // Makes sure that we don't force it to do it
                // do it when there's time
                // a precaution to make sure that we don't interrupt another thread
                DispatchQueue.main.async { // prevent background thread from interrupting the main thread, which handles user input
                    note.uiimage = img
                    completion()
                    print("completion")
                }
            }else{
                print("Error: \(error.debugDescription)")
            }
        }
        
    }

    // Date and time function
    static func findDateTime() -> String{
        // Creates a dateformatter and changes format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss_dd-MM-yyyy"
        
        // Creates a Date object to find the date and time
        let currDate = Date.init()
        
        // Returns string representation of date and time
        return dateFormatter.string(from: currDate)
    }
    
    static func uploadImage(data: Data) -> String{
        //let imgName = "picture_\(findDateTime()).jpg"
        let uuid = UUID().uuidString + ".jpg"
        let imgRef = storage.reference(withPath: uuid)
        imgRef.putData(data)
        return uuid
        
    }
}
