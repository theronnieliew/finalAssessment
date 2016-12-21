import UIKit
import Firebase
import FirebaseAuth

class MatchedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var savedIndexPath : IndexPath = IndexPath()
    var matchedUsers : [User] = []
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        fetchUser()
    }
    
    func populateTableView(){
        
    }
    
    func fetchUser(){
        ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("matchedList").observe(.childAdded , with: {(snapshot) in
            
            if let matchedID = snapshot.value as? String {
                self.fetchUserDetail(userID: matchedID)
            }
        })
    }
    
    func fetchUserDetail(userID : String){
        self.ref.child("users").child(userID).observeSingleEvent(of :.value, with: {(snapshot) in
            
            guard let userDict = snapshot.value as? [String: AnyObject] else{ return }
            
            let user = User()
            user.name = userDict["name"] as! String
            user.description = userDict["description"] as! String
            user.profilePicURL = userDict["profile-pic"] as! String
            user.age = userDict["age"] as! String
            user.email = userDict["email"] as! String
            user.gender = userDict["gender"] as! String
            
            self.matchedUsers.append(user)
            self.tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "candidateSegue" {
            var controller = segue.destination as! CandidateViewController
            
            let path = self.tableView.indexPathForSelectedRow!
            controller.user = matchedUsers[path.row]
            controller.delegate = self
        }
    }
}

extension MatchedViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : MatchedViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MatchedViewCell else {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = matchedUsers[indexPath.row].name
        cell.descLabel.text = matchedUsers[indexPath.row].description
        cell.profilePicView.loadImageUsingCacheWithUrlString(matchedUsers[indexPath.row].profilePicURL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            matchedUsers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //! update firebase
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "candidateSegue", sender: self)
        savedIndexPath = indexPath
    }
}

extension MatchedViewController : CandidateViewControllerDelegate{
    func deleteMatchedUser() {
        //!Delete here, then dismiss
        matchedUsers.remove(at: savedIndexPath.row)
        tableView.deleteRows(at: [savedIndexPath], with: .fade)
    }
}
