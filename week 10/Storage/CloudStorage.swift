//
//  CloudStorage.swift
//  10_ImageCloud
//
//  Created by Mads Bryde on 26/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import Foundation
import FirebaseStorage

class CloudStorage {
    private static let cloudStorage = Storage.storage()
    
    static func downloadImage(name:String, imageView:UIImageView){
        let imgRef = cloudStorage.reference(withPath: name) // get file handle
        // maxSixe = how big of an image should a user could download
        // makes sure that the file is downloaded before moving going in the "function"
        imgRef.getData(maxSize: 4000000){ (data, error) in
            if error == nil{
                print("success in dowloading img")
                
                let img = UIImage(data: data!)
                // Makes sure that we don't force it to do it
                // do it when there's time
                // a precaution to make sure that we don't interrupt another thread
                DispatchQueue.main.async { // prevent background thread from interrupting the main thread, which handles user input
                    imageView.image = img
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
        let imgRef = cloudStorage.reference(withPath: uuid)
        imgRef.putData(data)
        return uuid
        
    }
}
