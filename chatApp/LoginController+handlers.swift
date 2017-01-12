//
//  LoginController+handlers.swift
//  chatApp
//
//  Created by Ayso Lima Marques on 10/01/17.
//  Copyright © 2017 Ayso Lima marques. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("form is not valid")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            
            
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("form is not valid")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {
            (user: FIRUser?, error) in
            
            if error != nil {
                print(error!)
                return
            }
            guard let uid = FIRAuth.auth()?.currentUser?.uid else {
                return
            }
            
            //successfully authenticated user
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("Profile_images").child("\(imageName).jpg")
            
            if let uploadImage = UIImageJPEGRepresentation(self.profileImageView.currentImage!, 0.2) {
                
                storageRef.put(uploadImage, metadata: nil, completion: { (metaData, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if  let profileImageURL = metaData?.downloadURL()?.absoluteString {
                        let values:[String: Any] = ["name": name, "email":email, "profileImageUrl": profileImageURL]
                        
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])

                    }
                    
                    
                })
            }
            
        })
    }
    
    
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        
        let ref = FIRDatabase.database().reference(fromURL: "https://chatapp-672a3.firebaseio.com/")
        let userRef = ref.child("users").child(uid)
        //
        userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    private func ChangeProfileImage(uid: String, values: [String: AnyObject]) {
        
        
        
        
        let ref = FIRDatabase.database().reference(fromURL: "https://chatapp-672a3.firebaseio.com/")
        let userRef = ref.child("users").child(uid)
        //
        userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            
            
        })
        
        
    }
    
    
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        print(info)
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.setImage(selectedImage, for: UIControlState.normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
