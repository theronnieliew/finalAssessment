//
//  CandidateViewController.swift
//  finalAssessment
//
//  Created by Ronald Liew on 21/12/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit

protocol CandidateViewControllerDelegate {
    func deleteMatchedUser()
}


class CandidateViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emaillabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var user = User()
    var delegate : CandidateViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
    }
    
    func getUser(){
        nameLabel.text = user.name
        ageLabel.text = user.age
        genderLabel.text = user.gender
        emaillabel.text = user.email
        descriptionTextView.text = user.description
    }
    
    @IBAction func unmatchButtonTapped(_ sender: AnyObject) {
        //! Prompt Alert, on ok, send back, delete row
        let alertController = UIAlertController(title: "Confirm", message: "Are you sure you want to remove your match with this candidate?", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelButton = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        let confirmButton = UIAlertAction(title: "Yes", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            self.delegate?.deleteMatchedUser()
            self.navigationController?.popViewController(animated: true)
        })
        
        alertController.addAction(cancelButton)
        alertController.addAction(confirmButton)
        self.present(alertController, animated : true, completion:nil)
    }
}
