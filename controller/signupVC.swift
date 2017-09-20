import UIKit
import Firebase

class SignupVC {

  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var confirmPasswordField: UITextField!
  @IBOutlet weak var imagePreview: UIImageView!
  @IBOutlet weak var errorLabel: UILabel!
  
  let picker = UIImagePickerController()
 
  override func viewDidLoad() {
    super.viewDidLoad()
    picker.delegate = self

  }

  @IBAction func selectImage() {
    pickImage()
  }
  
  @IBAction func nextButtonPressed() {
    signupUser()
  }

}

extension SignupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func pickImage() {
    picker.allowsEditing = true
    picker.sourceType = .photoLibrary
    present(picker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
    if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
      self.imagePreview.image = image
    }
    self.dismiss(animated: true, completion: nil)
  }

}

extension SignupVC {
  
  var databaseReference:Database.database().reference() 
  var storageReference: Storage.storage().reference(forURL: "gs://finstagram.....com //insert whatever the storage ref is")
  var userStorageReference = storageReference.child("users")
  
  func signupUser() {
    guard nameField.text != "", emailField.text != "", passwordField.text != "", confirmPasswordField.text != "" else {return}
    if passwordField.text == confirmPasswordField.text {
      
      Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: {(user, error) in
     
      if error != nil {
        errorLabel.text = "Error registering user"
      }
      
      if let user = user {
      
      //create a display name for the user
      let changeRequest = Auth.auth()!.currentUser!.profileChangeRequest()
      changeRequest.displayName = self.nameField.text!
      changeRequest.commitChanges(completion: nil)
      
        let imageReference = self.userStorageReference.child("\(user.uid).jpg") // in our users file we're creating a user profile pic in a jpg format
        let imageData = UIImageJPEGRepresentation(self.imagePreview.image!, 0.5)
        let uploadImageData = imageReference.put(imageData, metadata: nil, completion: {(metadata, error) in
          if error != nil {
            print(error)
          } else {
          imageReference.downloadURL(completion: {(url, error) in
            if let url = url {
              let userInfo: [String: Any] = ["userId": user.uid, "username": self.nameField.text!, "urlToImage": url.absoluteString]
              self.databaseReference.child("users").child(user.uid).setValue(userInfo) //create the subfolder and put in the userInfo dictionary
              
              //create segue to user view controller
              let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
              self.present(vc, animated: true, completion: nil)
            }
          }
          }
        })
      }
        
      })
      
    } else {
      errorLabel.text = "Password does not match"  
    }
  }
  
}
