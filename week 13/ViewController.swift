//
//  ViewController.swift
//  13_ImageLabel
//
//  Created by Mads Bryde on 27/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    // two gesture recognizers which were added to the storyboard
    @IBOutlet var leftSwipe: UISwipeGestureRecognizer!
    @IBOutlet var rightSwipe: UISwipeGestureRecognizer!

    let imagePicker = UIImagePickerController() // handles fetching the image from the device
    
    @IBOutlet weak var textToPlaceOnImage: UITextField!
    var pointToPlaceText: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self // sets delegate of the imagepicker object to this class
        
        imageView.isUserInteractionEnabled = true // enables the user to swipe and the swipedTheImageView function to be called
        
        // sets the direction of the swipe gestures (this can also be done in storyboard)
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
    }

    // when pressing this button, it will present the photo library
    @IBAction func choosePhotoPressed(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true // allows the user to zoom in before selecting the picture
        present(imagePicker, animated: true, completion: nil)
    }
    
    // when pressing this button, the camera will show
    @IBAction func takePhotoPressed(_ sender: Any) {
        launchCamera()
    }
    
    // when pressing this button, the camera will show ready to capture video
    @IBAction func captureVideoPressed(_ sender: Any) {
        imagePicker.mediaTypes = ["public.movie"] // launches video mode
        imagePicker.videoQuality = .typeMedium // sets quality
        launchCamera()
    }
    
    
    // made a connection to one button to this outlet, and then pulled the other in the same
    // gave them tag values in the storyboard
    @IBAction func drawPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            //drawLine()
            return
        case 1:
            //drawSquare()
            return
        case 2:
            //drawCircle()
            return
        default:
            return
        }
    }
    
    // if you swipe left, the image will disappear
    @IBAction func swipedLeft(_ sender: UISwipeGestureRecognizer) {
        print("swiped left - remove picture")
        imageView.image = nil
    }
    
    // if you swipe right, you save the image
    @IBAction func swipedRight(_ sender: UISwipeGestureRecognizer) {
        print("swiped right - save picture")
        //guard let image = imageView.image else { return }
        
        // Oneliner which saves the image on the phone
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, nil, nil)
    }

    // saves the cgpoint of the touch in a variable
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: imageView){
            pointToPlaceText = point
        }
    }
    
    // when the image is tapped, it should place the text from the textField on the image
    // can't get it to place the text in the right place, but it does work, kinda
    // had problems with the CGpoint and the
    @IBAction func tappedImage(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended, let text = textToPlaceOnImage.text, let image = imageView.image, let point = pointToPlaceText{
            print("pressed")
            placeTxtOnImage(text: text, image: image, at: point)
        }
        
    }
    
    // launches the camera
    func launchCamera(){
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.showsCameraControls = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // the image picker, handles what happens when you picked an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("finished picking image")
        
        // handles if it's a video or an image
        if let url = info[.mediaURL] as? URL { // will only be true if it is a video
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path){
                UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil) // saves the video
            }
        }else{
            let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            imageView.image = image // shows the picture in the imageview
        }
        picker.dismiss(animated: true, completion: nil) //dismisses the picker
    }
    
    // function to place the text on the image
    func placeTxtOnImage(text:String, image:UIImage, at point: CGPoint){
        
        // Text setup
        let textColor = UIColor.black
        let textFont = UIFont(name: "Helvetica Bold", size: 36)!
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor
            ] as [NSAttributedString.Key : Any]
        
        // creates an NSAttributedString - it contains the draw method
        let attributedString = NSAttributedString(string: text, attributes: textFontAttributes)
        
        // makes an image context in the size of the image
        UIGraphicsBeginImageContext(image.size)
        
        // draws the image in the top left corner of the image context
        image.draw(at: CGPoint.zero)
                
        // makes an rectangle which should be at the point where the user pressed and in the size of the image, to get the cgpoints right
        let rect = CGRect(origin: point, size: image.size)
        // draw the string in the rect
        attributedString.draw(in: rect)
        
        // gets the image
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        // ends the image context
        UIGraphicsEndImageContext()
        
    }
}

