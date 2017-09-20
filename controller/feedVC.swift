import Firebase

class feedVC: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  var posts = [Posts]()
  var following = [String]()
  
  viewDidLoad(){
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
  }
}

extension feedVC: UITableViewDelegate, UITableViewDataSource {

  numberOfSections() {
    return 1
  }
  
  numberOfItemsInSection() {
    return posts.count
  }
  
  cellForRowAt() {
    let cell = tableView.dequeueReusableSell(withReuseIdenfitier: "PostCell", for: indexPath) as! PostCell
    
    //create the post
    
  
  }
}

extension feedVC {

    func fetchPosts() {
      // for the current user, find all the following users (users that your current user is following)
      // if userID of post matches that of the user we're following display their post
      
      let databaseReference = Database.database().reference()
      databaseReference.child("users").queryOrderedByKey().observeSingleEvent(of: .value) {(snapshot) in
         let users = snapshot.value as! [String: AnyObject] 
         for (_, value) in users {
          if let userID = value["userId"] as? String {
            if userID == FIRAuth.auth()?.currentUser?.uid {
              if let followingUsers = value["following"] as? [String: String] {
                for (_ , user) in followingUsers {
                  self.following.append(user)
                }
              }
              self.following.append(Auth.auth().currentUser!.uid) //add current user to the following array?
              
              databaseReference.child("posts").queryOrderedByKey().observeSingleEvent(of: .value) {(snap) in
                let postsSnap = snap.value as! [String: AnyObject] //this gives you all the posts
                //loop through all the posts and check if the post is one from a "following person"
                for (_, post) in postsSnap {
                  if let userID = value["userID"] as? String {
                    for each in self.following {
                      if each == userID {
                        let post = Post()
                        if let author = post["author"]
                      }
                    }
                  }
                }
              }                                                                                                  
          }
           
         }
    }

}
