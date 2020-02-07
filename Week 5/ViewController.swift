//
//  ViewController.swift
//  Hello World
//
//  Created by Mads Bryde on 07/02/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var HelloWorldText: UILabel!
    @IBOutlet weak var textInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnPressed(_ sender: UIButton) {
        // print(textInput.text!);
        //let name : String = textInput.text!;
        //HelloWorldText.text = "Hello " + name;
        //HelloWorldText.insert("!", at: HelloWorldText.endIndex);
        if let name = textInput.text {
            HelloWorldText.text = greetings(person: name);
        }
    }
    
    func greetings(person : String) -> String {
        let template = "Hello %@!";
        let greeting = String(format: template, person);
        //let greeting = "Hello " + person + "!";
        //let greeting = "Hello \(person)!";
        return greeting;
    }
    
}
