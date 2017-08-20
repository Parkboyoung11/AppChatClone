//
//  RegisterViewController.swift
//  MyRikkeiChat
//
//  Created by VuHongSon on 8/16/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//

import UIKit
import Firebase

let storage = Storage.storage()
let storageRef = storage.reference(forURL: "gs://appchatclone.appspot.com")
var ref: DatabaseReference!
var currentUser:User!

class RegisterViewController: UIViewController {
    @IBOutlet weak var brView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var txtRePwd: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnRes: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    var imgData:Data = Data()
    
    
    init() {
        super.init(nibName: "RegisterViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
        hideKeyboardWhenTappedAround()
        brView.myViewSkin()
        bgView.myViewSkin()
        imgAvatar.myImageSkin()
        btnRes.myButtonSkin()
        btnLogin.myButtonSkin()
        txtMail.myTextFieldSkin()
        txtPwd.myTextFieldSkin()
        txtRePwd.myTextFieldSkin()
        txtFullName.myTextFieldSkin()
        txtMail.delegate = self
        txtPwd.delegate = self
        txtRePwd.delegate = self
        txtFullName.delegate = self
        imgData = UIImagePNGRepresentation(UIImage(named: "Personalicon")!)!
    }
    
    @IBAction func btnResDid(_ sender: UIButton) {
        let email : String = txtMail.text!
        let pass : String = txtPwd.text!
        let repass : String = txtRePwd.text!
        let fullName : String = txtFullName.text!
        
        let emailChecked = email.checkEmail(mail: email)
        if !emailChecked {
            let noti = UIAlertController(title: "Warning", message: "Email address is not valid!", preferredStyle: .alert)
            let btn = UIAlertAction(title: "OK", style: .default, handler: nil)
            noti.addAction(btn)
            present(noti, animated: true, completion: nil)
        } else if pass == "" {
            let noti = UIAlertController(title: "Warning", message: "Please input Password!", preferredStyle: .alert)
            let btn = UIAlertAction(title: "OK", style: .default, handler: nil)
            noti.addAction(btn)
            present(noti, animated: true, completion: nil)
        } else if pass != repass {
            let noti = UIAlertController(title: "Warning", message: "These passwords don't match!", preferredStyle: .alert)
            let btn = UIAlertAction(title: "OK", style: .default, handler: nil)
            noti.addAction(btn)
            present(noti, animated: true, completion: nil)
        } else if fullName == "" {
            let noti = UIAlertController(title: "Warning", message: "Please input Your Name!", preferredStyle: .alert)
            let btn = UIAlertAction(title: "OK", style: .default, handler: nil)
            noti.addAction(btn)
            present(noti, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
                if (error == nil) {
                    print("Creat Account Succeeded")
                    Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                        if (error == nil) {
                            print("Sign In Succeeded")
                        }else {
                            print("Sign In Failed")
                        }
                    }
                    
                    let avatarRef = storageRef.child("images/\(email).jpg")
                    let uploadTask = avatarRef.putData(self.imgData, metadata: nil) { (metadata, error) in
                        guard let metadata = metadata else {
                            print("Upload Failed")
                            return
                        }
                        let downloadURL = metadata.downloadURL()
                        
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = fullName
                        changeRequest?.photoURL = downloadURL
                        changeRequest?.commitChanges { (error) in
                            if (error == nil) {
                                print("Upload Succeeded")
                                let user = Auth.auth().currentUser
                                if let user = user {
                                    let uid = user.uid
                                    let email = user.email
                                    let photoURL = user.photoURL
                                    let name = user.displayName
                                    currentUser = User(id: uid, email: email!, fullName: name!, photoURL: String(describing: photoURL!))
                                    
                                    let tableName = ref.child("users")
                                    let userid = tableName.child(currentUser.id)
                                    let user : Dictionary<String,String> = ["email": currentUser.email, "uid": currentUser.id , "fullName": currentUser.fullName, "photoURL": currentUser.photoURL]
                                    userid.setValue(user)
                                    print("Creat Database Succeeded")
                                    let url:URL = URL(string: currentUser.photoURL)!
                                    do{
                                        let data = try Data(contentsOf: url)
                                        currentUser.avatar = UIImage(data: data)
                                        print("Get Avatar Succeeded")
                                    }catch{
                                        print("Get Avatar Failed")
                                    }
                                    self.present(TabBarViewController(), animated: true, completion: nil)
                                }else {
                                    print("Creat Database Failed")
                                }
                                //self.changeToListChat()
                            } else {
                                print("Upload Failed")
                            }
                        }
                    }
                    uploadTask.resume()
                }else {
                    print("Creat Account Failed")
                    print(error ?? String())
                }
            }
        }
    }
    
    @IBAction func btnLoginDid(_ sender: UIButton) {
        present(LoginViewController(), animated: true, completion: nil)
//        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapAvatarDid(_ sender: UITapGestureRecognizer) {
        let alert:UIAlertController = UIAlertController(title: "Upload Profile Photo", message: "Choose one", preferredStyle: .alert)
        let btnPhoto:UIAlertAction = UIAlertAction(title: "Album", style: .default) { (UIAlertAction) in
            let imgPicker = UIImagePickerController()
            imgPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imgPicker.delegate = self
            imgPicker.allowsEditing = false
            self.present(imgPicker, animated: true, completion: nil)
        }
        
        let btnCamera:UIAlertAction = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
            if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                let imgPicker = UIImagePickerController()
                imgPicker.sourceType = UIImagePickerControllerSourceType.camera
                imgPicker.allowsEditing = false
                imgPicker.delegate = self
                self.present(imgPicker, animated: true, completion: nil)
            }else {
                print("No Camera")
            }
        }
        
        alert.addAction(btnPhoto)
        alert.addAction(btnCamera)
        present(alert, animated: true, completion: nil)
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imgChoose = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imgValue = max(imgChoose.size.width, imgChoose.size.height)
        if(imgValue > 2000){
            imgData = UIImageJPEGRepresentation(imgChoose, 0.3)!
        }else if imgValue > 1000 {
            imgData = UIImageJPEGRepresentation(imgChoose, 0.5)!
        } else {
            imgData = UIImagePNGRepresentation(imgChoose)!
        }
        
        imgAvatar.image = UIImage(data: imgData)
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
