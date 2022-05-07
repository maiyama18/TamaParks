import UIKit

public enum ImagePickers {
    public static func showCamera<C: UIViewController>(from originVC: C)
        where C: UIImagePickerControllerDelegate & UINavigationControllerDelegate
    {
        let picker = UIImagePickerController()
        picker.delegate = originVC
        picker.sourceType = .camera
        picker.allowsEditing = true
        originVC.present(picker, animated: true)
    }
}
