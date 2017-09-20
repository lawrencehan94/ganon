import UIKit
import Firebase

class uploadVC: UIViewController {

  @IBOutlet weak var: previewImage: UIImageView!
  @IBOutlet weak var: selectImageButton: UIButton!
  @IBOutlet weak var: postButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    picker.delegate = self
  }
  
  @IBAction func selectImage (_ sender: Any) {
    presentImagePicker()
  }
  
  @IBAction func createPost (_ sender: Any) {
    uploadPost()
  } 
}

// IMAGE PICKER
extension uploadVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func presentImagePicker() {
    picker.allowsEditing
    picker.sourceType = .photoLibrary
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String, Any]) {
    if let image = info[UIImagepickerControllerEditedImage] as? UIImage {
      self.previewImage.image = image
    }
  }
}

// Upload Post to Firebase (you also need to create a storage reference so you can store the image)
extension uploadVC {
  
  func uploadPost(){
    let userId = Auth.auth()!.currentUser!.uid
    let databaseReference = Database.database().reference()
    let storageReference = Storage.storage().reference(forURL: "gs://chat-box-6f8eb.appspot.com // or string from firebase storage")
   
    let postId = databaseReference.child("posts").childByAutoId().key // in database we are creating a new posts folder, childByAutoID organizes the posts, .key gives you a string
    let imageReference = storageReference.child("posts").child(userId).child("\(postId).jpg") // you want to store the posts under the user's folder
    
    //upload image by converting the image to a data
    let imageData = UIImageJPEGRepresentation(self.previewImage.image, 0.6) //0.6 is the compression size
    
    let uploadImageData = imageReference.put(imageData!, metadata: nil) { (metadata, error) in
      
      if error != nil {
        print(error!.localizedDescription)
        return
      } 
                                                                         
      imageReference.downloadURL(completion: { (url, error) in
        if let url = url {
          let feed = ["userID": userId, 
                      "pathToImage": url.absoluteString, 
                      "likes": 0, 
                      "author": Auth.auth()?.currentUser!.displayName!,
                      "postID": postId] as [String: Any]
          let postFeed = ["\(userId)": feed]
          databaseReference.child("posts").updateChildValues(postFeed) //you're uploading a dictionary back to firebase's dictionary
          self.dismiss(animated: true, completion: nil) //dismiss image picker controller
          }  
        })
      }
    
    // After Upload Image Data is finished, you need to resume uploading
    uploadImageData.resume()

}

