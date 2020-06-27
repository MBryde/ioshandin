//
//  PopUpViewController.swift
//  12_Map
//
//  Created by Mads Bryde on 27/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//
import UIKit
import MapKit

class PopUpViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subTitleTextField: UITextField!
    var annotation: MKPointAnnotation = MKPointAnnotation()
    
    // For now we don't need this, as we don't need to update the information on an annotation unless it's new
    //var newAnnotation: Bool = false
    
    // when the view loads, the textfields is set to that annotations title and subtitle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = annotation.title
        subTitleTextField.text = annotation.subtitle
    }
    
    // when we dismiss the view, the new annotation is saved in the database
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        annotation.title = titleTextField.text
        annotation.subtitle = subTitleTextField.text
        
        // if the user doesn't enter anything in the title field, the streetname and number will be saves as the title
        // components is a way of splitting
        if annotation.title == "" {
            annotation.title = annotation.subtitle?.components(separatedBy: ",")[0]
        }
        FirebaseRepo.addAnnotation(marker: annotation)
    }
}
