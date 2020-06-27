//
//  ViewController.swift
//  14_PersonalLogin
//
//  Created by Mads Bryde on 27/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import UIKit
import FirebaseUI

class ViewController: UIViewController, FUIAuthDelegate {
    
    // declaring the AuthUI
    //var authUI : FUIAuth?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func LoginButtonPressed(_ sender: Any) {
        
        // get the defauly Firebase UI object
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            //log the error
            return
        }
        
        let providers : [FUIAuthProvider] = [FUIGoogleAuth(), FUIEmailAuth()]
        authUI?.providers = providers
        
        //set ourself as delegate
        authUI?.delegate = self
        
        // get the reference to the AuthUI ViewController
        let authViewController = authUI!.authViewController()
        
        // shot the AuthUI controller
        present(authViewController, animated: true, completion: nil)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        // Check if their was an error
        guard error == nil else {
            // log the error
            return
        }
        
        print(authDataResult?.user.uid ?? "ERROR")
        
        performSegue(withIdentifier: "homeView", sender: self)
    }
}
