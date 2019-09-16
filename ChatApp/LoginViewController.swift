//
//  LoginViewController.swift
//  LChatApp
//
//  Created by Lucas on 9/10/19.
//  Copyright © 2019 Lucas. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    var ref: DatabaseReference!
    

    let profileImg: UIImageView = {
        let img = UIImageView()
//        img.image = UIImage(named: "")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.backgroundColor = UIColor.gray
        img.clipsToBounds = true
        img.isUserInteractionEnabled = true
        img.layer.cornerRadius = 50
        img.layer.masksToBounds = true

        return img
        
    }()


     let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view

    }()

    
    let loginRegisterButton: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = UIColor(r: 80, g: 101, b: 161)
//        btn.setTitle("Login", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        
        btn.addTarget(self, action: #selector(handleRegisterOrLogin), for: .touchUpInside)

        return btn
        
    }()
    
    
    let segement: UISegmentedControl = {
       let segement = UISegmentedControl(items: ["Login","Register"])
        segement.translatesAutoresizingMaskIntoConstraints = false
        segement.tintColor = UIColor.white
        segement.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        segement.selectedSegmentIndex = 1
        segement.addTarget(self, action: #selector(handleLogin(sender:)), for: .valueChanged)
        return segement
        
    }()
    
    @objc func handleLogin(sender:UISegmentedControl){
        let title = segement.titleForSegment(at: sender.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
    
        //change height of container
        heightAnchorContainer?.isActive = false
        heightAnchorContainer?.constant = sender.selectedSegmentIndex == 0 ? 100 : 150
        heightAnchorContainer?.isActive = true

        //change height of namefile
        heightAnchorName?.isActive = false
        heightAnchorName = nameTextFiled.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: sender.selectedSegmentIndex == 0 ? 0 : 1/3)
        heightAnchorName?.isActive = true
        
        heightAnchorEmail?.isActive = false
        heightAnchorEmail = emailTextFiled.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: sender.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        heightAnchorEmail?.isActive = true

        heightAnchorPassword?.isActive = false
        heightAnchorPassword = passwordTextFiled.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: sender.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        heightAnchorPassword?.isActive = true

    }
    
    
    func errDetail(err:Error){
        
        let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
        let act = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(act)
        self.present(alert, animated: true, completion: nil)

    }
    
    let nameTextFiled: UITextField = {
        let name = UITextField()
        name.placeholder =  "Name"
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    let emailTextFiled: UITextField = {
        let email = UITextField()
        email.placeholder =  "Email"
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()
    let passwordTextFiled: UITextField = {
        let password = UITextField()
        password.placeholder =  "Password"
        password.translatesAutoresizingMaskIntoConstraints = false
        return password
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        setupConstraint()
        // Do any additional setup after loading the view.
        gobackBar()
        loginRegisterButton.setTitle(segement.titleForSegment(at: 1), for:.normal)

    }
    
    
    
    func gobackBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(cancel))
    }
    @objc  func cancel()
    {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    var heightAnchorContainer: NSLayoutConstraint?
    var heightAnchorName: NSLayoutConstraint?
    var heightAnchorEmail: NSLayoutConstraint?
    var heightAnchorPassword: NSLayoutConstraint?

    //MARK: SET CONSTRAINTS
    func setupConstraint(){
        
        view.addSubview(inputContainerView)
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        heightAnchorContainer = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        heightAnchorContainer?.isActive = true

        view.addSubview(segement)
        segement.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segement.bottomAnchor.constraint(equalTo:inputContainerView.topAnchor, constant:-10).isActive = true
        segement.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        segement.heightAnchor.constraint(equalToConstant: 30).isActive = true

        view.addSubview(profileImg)
        profileImg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImg.bottomAnchor.constraint(equalTo:segement.topAnchor, constant: -10).isActive = true
        profileImg.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor,multiplier: 0.5).isActive = true
        profileImg.heightAnchor.constraint(equalToConstant: 200).isActive = true

        profileImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImg)))

        view.addSubview(loginRegisterButton)
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo:inputContainerView.bottomAnchor,constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
        view.addSubview(nameTextFiled)
        nameTextFiled.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextFiled.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor,constant: 10).isActive = true
        nameTextFiled.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        heightAnchorName = nameTextFiled.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        heightAnchorName?.isActive = true
        
        view.addSubview(emailTextFiled)
        emailTextFiled.topAnchor.constraint(equalTo: nameTextFiled.bottomAnchor).isActive = true
        emailTextFiled.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor,constant: 10).isActive = true
        emailTextFiled.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        heightAnchorEmail = emailTextFiled.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        heightAnchorEmail?.isActive = true
        
        view.addSubview(passwordTextFiled)
        passwordTextFiled.topAnchor.constraint(equalTo: emailTextFiled.bottomAnchor).isActive = true
        passwordTextFiled.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor,constant: 10).isActive = true
        passwordTextFiled.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        heightAnchorPassword = passwordTextFiled.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        heightAnchorPassword?.isActive = true

        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    deinit {
        print("deinit")
    }
    
}

func showErrorDetail(err:Error){
    
    
}


extension UIColor {
    
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat){
        
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)

    }
    
    
}

