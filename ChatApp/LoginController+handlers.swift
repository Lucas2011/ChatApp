//
//  LoginController+handlers.swift
//  Chatdemo
//
//  Created by Lucas on 9/11/19.
//  Copyright © 2019 Lucas. All rights reserved.
//

import UIKit
import Firebase


extension LoginViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func selectImg(){

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImagePicker : UIImage?

        if let editedImage = info[.editedImage] as? UIImage  {
            selectedImagePicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage{
            selectedImagePicker = originalImage

        }
        
        if let selectedImage = selectedImagePicker{
            profileImg.image = selectedImage
        }
        
        
        picker.dismiss(animated: true, completion: nil)

    }
    
    //MARK: UserRegistration
    @objc func handleRegister(){
        guard let email  = emailTextFiled.text , let password = passwordTextFiled.text, let name = nameTextFiled.text else {return}
        
        guard let image = profileImg.image else {
            let alert = UIAlertController(title: "Error", message: "Please uplodate a profile picture", preferredStyle: .alert)
            let act = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(act)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (res, err) in
            if err != nil{
                self?.errDetail(err: err!)
                return
            }
            
            guard let uid = res?.user.uid else {return}

            //unique imageName
            let imgName = NSUUID().uuidString
            //upload Data
            let storageRef = Storage.storage().reference().child("profileImages").child("\(imgName).png")
           
            //adjust profile imamge rate 0.3
            if let uploadingImg = image.jpegData(compressionQuality:0.3){
                storageRef.putData(uploadingImg, metadata: nil, completion: { [weak self](metadata, err) in
                    guard let _ = metadata else {return}
                 
                    storageRef.downloadURL(completion: { (url, err) in
                        guard let url = url?.absoluteString else {return}
                        let value = ["name":name , "email":email,"profileImgUrl":url]
                        self?.registerUsersIntoDataBaseWithUID(values: value,uid: uid)
                    })
                    
                })
            }
            
            

        }
    }
    
    private func registerUsersIntoDataBaseWithUID(values:[String:Any],uid:String){
        
        FBNetworking.shared.registerUsersI(subChild: "users", uid: uid, values: values) { (data, err) in
            if err != nil{
                self.errDetail(err: err!)
                return
            }
            self.present(UINavigationController(rootViewController: MessageController()), animated: true, completion: nil)
            print("saved data to firebase")

        }
        
    }
    
    func handleLogin(){
        
        guard let email = emailTextFiled.text , let password = passwordTextFiled.text  else {
            print("invailde form")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self](ref, err) in
            if err != nil{
                self?.errDetail(err: err!)
                return
            }
            self?.present(UINavigationController(rootViewController: MessageController()), animated: true, completion: nil)
            //sucessfully logged in our user
//            self?.dismiss(animated: true, completion: nil)
            
        }
        
    }
    @objc func handleRegisterOrLogin(){
        
        segement.selectedSegmentIndex == 0 ? handleLogin() : handleRegister()
        
    }
    

}



