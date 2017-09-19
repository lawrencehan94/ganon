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
