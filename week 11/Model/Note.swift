//
//  Note.swift
//  11_CustomTables
//
//  Created by Mads Bryde on 27/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import Foundation
import UIKit

class Note{
    var id: String?
    var dateTime: String?
    var title: String?
    var body: String?
    var image: String?
    var uiimage: UIImage?
    
    init (id: String){
        self.id = id
        self.title = "New note"
        self.body = "Enter text here..."
        self.image = ""
        self.dateTime = returnDate()
    }
    
    init (id: String, dateTime: String, title: String, body: String, image: String){
        self.id = id
        self.title = title
        self.body = body
        self.image = image
        self.dateTime = returnDate()
    }
    
    func hasImage() -> Bool {
        if uiimage != nil{
            return true
        }else{
            return false
        }
    }
    
    func returnDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss dd/MM/yyyy"
        let currentDate = Date.init()
        return dateFormatter.string(from: currentDate)
    }
}
