//
//  ViewController.swift
//  11_CustomTables
//
//  Created by Mads Bryde on 27/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var image: UIImageView!
    var note: Note?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let note = note{
            titleTextField.text = note.title
            bodyTextView.text = note.body
            image.image = note.uiimage
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let note = note{
            note.title = titleTextField.text
            note.body = bodyTextView.text
            CloudFirebase.update(note: note)
        }
    }
}

