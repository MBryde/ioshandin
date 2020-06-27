//
//  Note.swift
//  10_ImageCloud
//
//  Created by Mads Bryde on 26/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import Foundation

class Note{
    var id: String?
    var dateTime: String?
    var headline: String?
    var body: String?
    var image: String?
    
    // This will be used when adding a new note from the button
    init (id: String, headline: String, body: String){
        self.id = id
        self.headline = headline
        self.body = body
        self.image = ""
        self.dateTime = returnDate()
    }
    
    // This will be used when creating a new node from the database.
    init (id: String, dateTime: String, headline: String, body: String, image: String){
        self.id = id
        self.headline = headline
        self.body = body
        self.image = image
        self.dateTime = returnDate()
    }
    
    func returnDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss dd/MM/yyyy"
        let currentDate = Date.init()
        return dateFormatter.string(from: currentDate)
    }
}

