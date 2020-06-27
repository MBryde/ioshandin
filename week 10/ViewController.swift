//
//  ViewController.swift
//  10_ImageCloud
//
//  Created by Mads Bryde on 26/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var headlineText: UITextField!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var bodyText: UITextView!
    @IBOutlet weak var imageField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var note: Note?
    var picFromCam = false
    var newImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let note = note {
            headlineText.text = note.headline
            dateTimeLabel.text = note.dateTime
            bodyText.text = note.body
            if let image = note.image, note.image != "empty" {
                imageField.text = note.image
                CloudStorage.downloadImage(name: image, imageView: imageView)
            } else if note.image == "empty" {
                print("Note doesn't contain an image")
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let newImage = newImage, let imgJPG = newImage.jpegData(compressionQuality: 0.5), let note = note{
            note.image = CloudStorage.uploadImage(data: imgJPG)
            self.note = note
            
        }else if let note = note, let image = imageField.text{
            note.image = image
            self.note = note
        }
        
        if let note = note{
            CloudFirebase.update(id: note.id!, dateTime: dateTimeLabel.text!, headline: headlineText.text!, body: bodyText.text, image: imageField.text!)
        }
        
    }

    @IBAction func uploadImageButton(_ sender: Any) {
        if imageField.text == "new image - not in db yet"{
            print("Will upload when closing notes")
            
        }else if let note = note, let imageName = imageField.text{
                note.image = imageName
                CloudStorage.downloadImage(name: imageName, imageView: imageView)
                
            CloudFirebase.update(id: note.id!, dateTime: dateTimeLabel.text!, headline: headlineText.text!, body: bodyText.text, image: imageField.text!)
        }
        
    }

    @IBAction func cameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            print("in camera if")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            print("Picture from library: \(imagePicker.description)")
        }
    }
    
    @IBAction func photoLibraryButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            print("in photolibrary if")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            print("Picture from library: \(imagePicker.description)")
        }
    }
    
    // Function that executes when an image is picked from library (or camera?)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        }else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        }else {
            return
        }

        // sets the imageviews image to be the image chosen from the library and maybe camera
        imageView.image = newImage
        imageField.text = "new image - not in db yet"
        dismiss(animated: true)
    }

}

