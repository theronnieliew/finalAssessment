import UIKit
import Firebase
import FirebaseDatabase
//import FirebaseStorage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilepicView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var ref: FIRDatabaseReference!
    var user = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        fetchUser()
    }
    
    func fetchUser(){
        ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value , with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                self.nameLabel.text = dictionary["name"] as? String
                self.emailLabel.text = dictionary["email"] as? String
                self.ageLabel.text = dictionary["age"] as? String
                self.genderLabel.text = dictionary["gender"] as? String
                self.user.profilePicURL = (dictionary["profile-pic"] as? String)!
                self.descriptionTextView.text = dictionary["description"] as? String
                
                self.profilepicView.loadImageUsingCacheWithUrlString(self.user.profilePicURL)
                self.profilepicView.layer.cornerRadius = self.profilepicView.frame.size.width / 2
                self.profilepicView.clipsToBounds = true
            }
        })
    }
    
    @IBAction func editButtonTapped(_ sender: AnyObject) {
        
    }

}
