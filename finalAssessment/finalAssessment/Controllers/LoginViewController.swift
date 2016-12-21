//
//  LoginViewController.swift
//  finalAssessment
//
//  Created by Ronald Liew on 21/12/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.addTarget(self, action: #selector(loginButtonTapped(button:)), for: .touchUpInside)
        }
    }

    @IBOutlet weak var signupButton: UIButton!{
        didSet{
            signupButton.addTarget(self, action: #selector(signUpButtonTapped(button:)), for: .touchUpInside)
        }
    }
    
    var ref : FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        self.navigationItem.title = "LOG IN"
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc private func loginButtonTapped(button : UIButton){
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user,error) in
            
            if let authAerror = error{
                AlertController.alertPopUp(viewController: self, titleMsg: "Error", message: "Either username or password contains an error", cancelMsg: "Ok")
                return
            }
            
            guard let firUser = user else{ return }
            
            self.notifySuccessLogin()
            print("Successfully logged in!")
        })
    }
    
    func notifySuccessLogin(){
        let authSuccessNoification = Notification(name: Notification.Name(rawValue:"AuthSuccessNotification"))
        NotificationCenter.default.post(authSuccessNoification)
    }
    
    @objc private func signUpButtonTapped(button : UIButton){
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
}

extension LoginViewController : SignUpViewControllerDelegate{
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
