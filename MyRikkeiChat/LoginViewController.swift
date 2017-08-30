//
//  LoginViewController.swift
//  MyRikkeiChat
//
//  Created by VuHongSon on 8/17/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var gbView: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRes: UIButton!

    init() {
        super.init(nibName: "LoginViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lock = 0
        hideKeyboardWhenTappedAround()
        gbView.myViewSkin()
        txtEmail.myTextFieldSkin()
        txtPass.myTextFieldSkin()
        btnLogin.myButtonSkin()
        btnRes.myButtonSkin()
        txtEmail.delegate = self
        txtPass.delegate = self
    }

    @IBAction func btnLoginDid(_ sender: UIButton) {
        let email : String = txtEmail.text!
        let pass : String = txtPass.text!
        
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
        } else {
            
            
            let alertActivity:UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
            let activity:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            activity.color = #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 1)
            alertActivity.view.addSubview(activity)
            activity.centerXAnchor.constraint(equalTo: alertActivity.view.centerXAnchor).isActive = true
            activity.centerYAnchor.constraint(equalTo: alertActivity.view.centerYAnchor).isActive = true
            activity.heightAnchor.constraint(equalTo: alertActivity.view.heightAnchor).isActive = true
            activity.widthAnchor.constraint(equalTo: activity.heightAnchor).isActive = true
            activity.startAnimating()
            self.present(alertActivity, animated: true, completion: nil)
            Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                if error == nil {
                    activity.stopAnimating()
                    alertActivity.dismiss(animated: true, completion: nil)
                    print("Sign In Succeeded")
                    self.present(TabBarViewController(), animated: true, completion: nil)
                }else {
                    activity.stopAnimating()
                    alertActivity.dismiss(animated: true, completion: nil)
                    print("Sign In Failed")
                    let noti = UIAlertController(title: "Sign In Failed", message: "Please chech again!", preferredStyle: .alert)
                    let btn = UIAlertAction(title: "OK", style: .default, handler: nil)
                    noti.addAction(btn)
                    self.present(noti, animated: true, completion: nil)
                }
            }
            
            
            
            Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                if (error == nil) {
                    print("Sign In Succeeded")
                    let uid = user?.uid
                    let email = user?.email
                    let photoURL = user?.photoURL
                    let name = user?.displayName
                    currentUser = User(id: uid!, email: email!, fullName: name!, photoURL: String(describing: photoURL!))
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
                    print("Sign In Failed")
                    let noti = UIAlertController(title: "Sign In Failed", message: "Please chech again!", preferredStyle: .alert)
                    let btn = UIAlertAction(title: "OK", style: .default, handler: nil)
                    noti.addAction(btn)
                    self.present(noti, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnResDid(_ sender: UIButton) {
        present(RegisterViewController(), animated: true, completion: nil)
    }
    
    @IBAction func btnForgotPass(_ sender: UIButton) {
        print("Ahihi. Dont have this function. Please wait a long time :v")
    }
    
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

