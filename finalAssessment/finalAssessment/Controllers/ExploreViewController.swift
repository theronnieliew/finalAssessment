import UIKit
import Firebase

class ExploreViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var mehButton: UIButton!{
        didSet{
            mehButton.addTarget(self, action: #selector(mehButtonPressed(button:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var yasButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    var ref: FIRDatabaseReference!
    var users : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        fetchUsers()
    }
    
    func fetchUsers(){
        ref.child("users").observe(.childAdded, with: {(snapshot) in
            guard let dic = snapshot.value as? [String: AnyObject] else{ return }
            
            let user = User()
            user.name = dic["name"] as! String
            user.age = dic["age"] as! String
            user.profilePicURL = dic["profile-pic"] as! String
            self.users.append(user)
            self.populateFeed()
        })
    }
    
    func populateFeed(){
        userImageView.loadImageUsingCacheWithUrlString(users[0].profilePicURL)
        nameLabel.text = users[0].name
        ageLabel.text = users[0].age
    }
    
    func mehButtonPressed(button : UIButton){
        userImageView.loadImageUsingCacheWithUrlString(users[1].profilePicURL)
        nameLabel.text = users[1].name
        ageLabel.text = users[1].age
        //! Add to unwanted list in CURRENT USERs unmatchedList
    }
    
    func yasButtonPressed(button : UIButton){
        //! Add to current user wanted list
    }

    @IBAction func matchesButtonTapped(_ sender: AnyObject) {
    }
    
    @IBAction func profileButtonTapped(_ sender: AnyObject) {
        //!Segue to profile
    }
}
