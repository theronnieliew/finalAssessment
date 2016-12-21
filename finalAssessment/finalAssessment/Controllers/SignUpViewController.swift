//
//  SignUpViewController.swift
//  finalAssessment
//
//  Created by Ronald Liew on 21/12/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profilePictureView: UIImageView!
    
    @IBOutlet weak var createAccountButton: UIButton!{
        didSet{
            createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped(button:)), for: .touchUpInside)
        }
    }
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        self.navigationItem.title = "SIGN UP"
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func createAccountButtonTapped(button : UIButton){
        
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text
            else { return }
        
        if password.characters.count < 6 {
            AlertController.alertPopUp(viewController: self, titleMsg: "Error", message: "Please assure your password contains at least 6 or more charaters", cancelMsg: "Ok")
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user,error) in
            if let authError = error{ return }
            
            guard let firUser = user else { return }
            
            self.notifySuccessfulSignUp()
            
            //!Give default icon
            let pic = "https://firebasestorage.googleapis.com/v0/b/finalassessment-fed76.appspot.com/o/defaultIcon.png?alt=media&token=2f00d4fd-c75f-414d-aabe-5934c3d8197b"
            
            self.ref.child("users").child((user?.uid)!).setValue(["email" : email, "name" : name, "profile-pic" : pic])
            
            print("Successfully registered you nigga!!")
        })
    }
    
    func notifySuccessfulSignUp(){
        
        let authSuccessNotification = Notification(name: Notification.Name(rawValue: "AuthSuccessNotification"))
        
        NotificationCenter.default.post(authSuccessNotification)
    }
}