//
//  DetailedViewController.swift
//  Personal Notebook
//
//  Created by Mads Bryde on 25/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

    var notes : Note?
    @IBOutlet weak var headLineText: UITextField!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var backButton: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        //print("HEADLINE: \(notes?.headline ?? "NO HEADLINE") TEXT: \(notes?.text ?? "NO TEXT")")
        // Do any additional setup after loading the view.
        headLineText.text = notes?.headline
        textField.text = notes?.text
    }
}
