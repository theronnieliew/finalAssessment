import UIKit
import Firebase

class ExploreViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var mehButton: UIButton!{
        didSet{
            mehButton.addTarget(self, action: #selector(mehButtonPressed(button:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var yasButton: UIButton!{
        didSet{
            yasButton.addTarget(self, action: #selector(yasButtonPressed(button:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    var feedIndexTracker = 0
    
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
            
            print("users! : \(snapshot.value)")
            let user = User()
            user.name = dic["name"] as! String
            user.age = dic["age"] as! String
            user.profilePicURL = dic["profile-pic"] as! String
            user.ID = dic["id"] as! String
//            user.matchedList = dic["matchedList"] as! [String]
//            user.unMatchedList = dic["unMatchedList"] as! [String]
            
            
            //! Check not to include yourself, your likes and dislikes
            if(user.ID == FIRAuth.auth()?.currentUser?.uid){
            } else {
                self.users.append(user)
                for user in self.users{
                    print("USERS : \(user.name)")
                }
            }
            self.populateFeed()
        })
    }
    
    func populateFeed(){
        userImageView.loadImageUsingCacheWithUrlString(users[feedIndexTracker].profilePicURL)
        nameLabel.text = users[feedIndexTracker].name
        ageLabel.text = users[feedIndexTracker].age
    }
    
    func mehButtonPressed(button : UIButton){
        if feedIndexTracker < users.count - 1{
            feedIndexTracker += 1
            userImageView.loadImageUsingCacheWithUrlString(users[feedIndexTracker].profilePicURL)
            nameLabel.text = users[feedIndexTracker].name
            ageLabel.text = users[feedIndexTracker].age
            
            ref.child("users").child(users[feedIndexTracker].ID).observeSingleEvent(of: .value, with: {(snapshot) in
                
                if !snapshot.exists() { return }
                
                print("snapshot! : \(snapshot)")
                
                if let dict = snapshot.value as? Dictionary<String, AnyObject>{
                    var unMatchedList: [String] = []
                    if dict["unMatchedList"] != nil {
                        unMatchedList = dict["unMatchedList"] as! [String]
                    } else {
                        unMatchedList = []
                    }
                    
                    print("UnMatched List! : \(unMatchedList)")
                    unMatchedList.append(snapshot.key)
                    
                    self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).updateChildValues(["unMatchedList": unMatchedList])
                }
            })
        } else {
            AlertController.alertPopUp(viewController: self, titleMsg: "Sorry", message: "We're out of users", cancelMsg: "Ok")
            return
        }
    }
    
    func yasButtonPressed(button : UIButton){
        
        if feedIndexTracker < users.count - 1{
            feedIndexTracker += 1
            userImageView.loadImageUsingCacheWithUrlString(users[feedIndexTracker].profilePicURL)
            nameLabel.text = users[feedIndexTracker].name
            ageLabel.text = users[feedIndexTracker].age
            
            ref.child("users").child(users[feedIndexTracker].ID).observeSingleEvent(of: .value, with: {(snapshot) in
                
                if !snapshot.exists() { return }
                
                print("snapshot! : \(snapshot)")
                
                if let dict = snapshot.value as? Dictionary<String, AnyObject>{
                    var matchedList: [String] = []
                    if dict["matchedList"] != nil {
                        matchedList = dict["matchedList"] as! [String]
                    } else {
                        matchedList = []
                    }
                    
                    print("Matched List! : \(matchedList)")
                    matchedList.append(snapshot.key)
                    
                    self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).updateChildValues(["matchedList": matchedList])
                }
            })
        }
        else {
            AlertController.alertPopUp(viewController: self, titleMsg: "Sorry", message: "We're out of users", cancelMsg: "Ok")
            return
        }
    }

    @IBAction func matchesButtonTapped(_ sender: AnyObject) {
    }
    
    @IBAction func profileButtonTapped(_ sender: AnyObject) {
        performSegue(withIdentifier: "profileSegue", sender: self)
    }
}
