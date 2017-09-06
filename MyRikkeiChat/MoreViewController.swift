//
//  MoreViewController.swift
//  MyRikkeiChat
//
//  Created by VuHongSon on 8/18/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//

import UIKit
import Firebase

class MoreViewController: UIViewController {
    
    var imgData:Data = Data()
    
    let nameTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textField.backgroundColor = UIColor.white
        textField.placeholder = " 👀 Your Full Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let viewSP : UIView = {
        let viewSP = UIView()
        viewSP.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        viewSP.translatesAutoresizingMaskIntoConstraints = false
        return viewSP
    }()
    
    let textFieldBorderView : UIView = {
        let textFieldBorderView = UIView()
        textFieldBorderView.backgroundColor = UIColor.white
        textFieldBorderView.layer.borderWidth = 1
        textFieldBorderView.layer.borderColor = UIColor.brown.cgColor
        textFieldBorderView.layer.cornerRadius = 5
        textFieldBorderView.layer.masksToBounds = true
        textFieldBorderView.translatesAutoresizingMaskIntoConstraints = false
        return textFieldBorderView
    }()
    
    
    let imgAvatar : UIImageView = {
        let imgView = UIImageView()
        imgView.isUserInteractionEnabled = true
        imgView.image = #imageLiteral(resourceName: "Personalicon")
        imgView.myImageSkin()
        imgView.contentMode = UIViewContentMode.scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let updateButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Update", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.0368008456, green: 0.08081357971, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.05117796371, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(btnUpdateDid), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        navigationItem.title = "Update"
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutDid)), animated: true)
        setupView()
        nameTextField.delegate = self
        
    }
    
    func setupView() {
        
        view.addSubview(viewSP)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" :  viewSP]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : viewSP]))
        
        viewSP.addSubview(textFieldBorderView)
        viewSP.addSubview(imgAvatar)
        viewSP.addSubview(updateButton)
        
        viewSP.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[v0(35)]-20-[v1(170)]-20-[v2(35)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : textFieldBorderView , "v1" : imgAvatar , "v2" : updateButton]))
        viewSP.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : textFieldBorderView]))
        imgAvatar.centerXAnchor.constraint(equalTo: viewSP.centerXAnchor).isActive = true
        imgAvatar.widthAnchor.constraint(equalTo: imgAvatar.heightAnchor).isActive = true
        updateButton.centerXAnchor.constraint(equalTo: viewSP.centerXAnchor).isActive = true
        updateButton.widthAnchor.constraint(equalTo: textFieldBorderView.widthAnchor, multiplier: 1/3).isActive = true
        
        textFieldBorderView.addSubview(nameTextField)
        textFieldBorderView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : nameTextField]))
        textFieldBorderView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[v0]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : nameTextField]))
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAvatarDid(sender:)))
        imgAvatar.addGestureRecognizer(gesture)
    }
    
    func logOutDid() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            currentUser = nil
            visitor = nil
            indexSS = -1
            present(LoginViewController(), animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func btnUpdateDid() {
        let updateName = nameTextField.text
        let updateAvatar = imgAvatar.image
        let alertActivity:UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let activity:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activity.color = #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 1)
        alertActivity.view.addSubview(activity)
        activity.centerXAnchor.constraint(equalTo: alertActivity.view.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: alertActivity.view.centerYAnchor).isActive = true
        activity.heightAnchor.constraint(equalTo: alertActivity.view.heightAnchor).isActive = true
        activity.widthAnchor.constraint(equalTo: activity.heightAnchor).isActive = true
        
        if updateName == "" && imgAvatar.image == #imageLiteral(resourceName: "Personalicon") {
            let noti = UIAlertController(title: "Warning", message: "Please input Your Update Name or Avatar!", preferredStyle: .alert)
            let btn = UIAlertAction(title: "OK", style: .default, handler: nil)
            noti.addAction(btn)
            present(noti, animated: true, completion: nil)
        }else if updateName != "" && imgAvatar.image != #imageLiteral(resourceName: "Personalicon"){
            
            activity.startAnimating()
            self.present(alertActivity, animated: true, completion: nil)
            
            let avatarRef = storageRef.child("images/\(currentUser.email!).jpg")
            let uploadTask = avatarRef.putData(self.imgData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    print("Upload Failed")
                    return
                }
                let downloadURL = metadata.downloadURL()
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = updateName!
                changeRequest?.photoURL = downloadURL
                changeRequest?.commitChanges { (error) in
                    if (error == nil) {
                        
                        activity.stopAnimating()
                        alertActivity.dismiss(animated: true, completion: nil)
                        
                        print("Upload Update Succeeded")
                        currentUser.fullName = updateName
                        currentUser.photoURL = String(describing: downloadURL!)
                        ref.child("users").child(currentUser.id).child("fullName").setValue(updateName)
                        ref.child("users").child(currentUser.id).child("photoURL").setValue(String(describing: downloadURL!))
                        self.imgAvatar.image = #imageLiteral(resourceName: "Personalicon")
                        self.nameTextField.text = ""
                        let noti = UIAlertController(title: "Congratulations", message: "Update Your Name vs Avatar Succeeded!", preferredStyle: .alert)
                        let btn = UIAlertAction(title: "OK", style: .default, handler: nil)
                        noti.addAction(btn)
                        self.present(noti, animated: true, completion: nil)
                    } else {
                        
                        activity.stopAnimating()
                        alertActivity.dismiss(animated: true, completion: nil)
                        
                        print("Upload Update Failed")
                        self.imgAvatar.image = #imageLiteral(resourceName: "Personalicon")
                        self.nameTextField.text = ""
                        let noti = UIAlertController(title: "Warning", message: "Sorry, Update Your Name vs Avatar Failed. Please try again!", preferredStyle: .alert)
                        let btn = UIAlertAction(title: "OK", style: .default, handler: nil)
                        noti.addAction(btn)
                        self.present(noti, animated: true, completion: nil)
                    }
                }
            }
            uploadTask.resume()
        }else if updateAvatar == #imageLiteral(resourceName: "Personalicon") {
            
            activity.startAnimating()
            self.present(alertActivity, animated: true, completion: nil)
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = updateName!
            changeRequest?.commitChanges { (error) in
                if (error == nil) {
                    
                    activity.stopAnimating()
                    alertActivity.dismiss(animated: true, completion: nil)
                    
                    print("Upload Your Name Succeeded")
                    currentUser.fullName = updateName
                    ref.child("users").child(currentUser.id).child("fullName").setValue(updateName)
                    self.nameTextField.text = ""
                    let noti = UIAlertController(title: "Congratulations", message: "Update Your Name Succeeded!", preferredStyle: .alert)
                    let btn = UIAlertAction(title: "OK", style: .default, handler: nil)
                    noti.addAction(btn)
                    self.present(noti, animated: true, completion: nil)
                } else {
                    
                    activity.stopAnimating()
                    alertActivity.dismiss(animated: true, completion: nil)
                    
                    print("Upload Your Name Failed")
                    self.nameTextField.text = ""
                    let noti = UIAlertController(title: "Warning", message: "Sorry, Update Your Name Failed. Please try again!", preferredStyle: .alert)
                    let btn = UIAlertAction(title: "OK", style: .default, handler: nil)
                    noti.addAction(btn)
                    self.present(noti, animated: true, completion: nil)
                }
            }
        }else if updateName == "" {
            
            activity.startAnimating()
            self.present(alertActivity, animated: true, completion: nil)
            
            let avatarRef = storageRef.child("images/\(currentUser.email).jpg")
            let uploadTask = avatarRef.putData(self.imgData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    print("Upload Failed")
                    return
                }
                let downloadURL = metadata.downloadURL()
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = downloadURL
                
                changeRequest?.commitChanges { (error) in
                    if (error == nil) {
                        
                        activity.stopAnimating()
                        alertActivity.dismiss(animated: true, completion: nil)
                        
                        print("Upload Update Succeeded")
                        currentUser.photoURL = String(describing: downloadURL!)
                        ref.child("users").child(currentUser.id).child("photoURL").setValue(String(describing: downloadURL!))
                        self.imgAvatar.image = #imageLiteral(resourceName: "Personalicon")
                        let noti = UIAlertController(title: "Congratulations", message: "Update Your Avatar Succeeded!", preferredStyle: .alert)
                        let btn = UIAlertAction(title: "OK", style: .default, handler: nil)
                        noti.addAction(btn)
                        self.present(noti, animated: true, completion: nil)
                    } else {
                        
                        activity.stopAnimating()
                        alertActivity.dismiss(animated: true, completion: nil)
                        
                        print("Upload Update Failed")
                        self.imgAvatar.image = #imageLiteral(resourceName: "Personalicon")
                        let noti = UIAlertController(title: "Warning", message: "Sorry, Update Your Avatar Failed. Please try again!", preferredStyle: .alert)
                        let btn = UIAlertAction(title: "OK", style: .default, handler: nil)
                        noti.addAction(btn)
                        self.present(noti, animated: true, completion: nil)
                    }
                }
            }
            uploadTask.resume()
        }
        
    }

    func tapAvatarDid(sender: UITapGestureRecognizer) {
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

extension MoreViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imgChoose = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imgValue = max(imgChoose.size.width, imgChoose.size.height)
        if(imgValue > 1000){
            imgData = UIImageJPEGRepresentation(imgChoose, 0.1)!
        }else if imgValue > 500 {
            imgData = UIImageJPEGRepresentation(imgChoose, 0.2)!
        } else {
            imgData = UIImagePNGRepresentation(imgChoose)!
        }
        
        imgAvatar.image = UIImage(data: imgData)
        dismiss(animated: true, completion: nil)
    }
}

extension MoreViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
