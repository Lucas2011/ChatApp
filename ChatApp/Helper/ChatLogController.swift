//
//  ChatLogController.swift
//  Chatdemo
//
//  Created by Lucas on 9/13/19.
//  Copyright © 2019 Lucas. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UIViewController,UITextFieldDelegate {
    var User:UserModel?
    let textFiled = UITextField()
    let ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = User?.name
        setupUI()
    }

    func setupUI(){
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
//        bottomView.backgroundColor = UIColor.red
        
        let topLine = UIView()
        topLine.translatesAutoresizingMaskIntoConstraints = false
        topLine.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        

        let btn =  UIButton(type: .system)
        btn.setTitle("Send", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.delegate = self
        textFiled.placeholder = "Enter message..."
        
        view.addSubview(bottomView)
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -30).isActive = true
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant:50).isActive = true
      
        view.addSubview(topLine)
        topLine.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        topLine.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topLine.heightAnchor.constraint(equalToConstant:1).isActive = true

        view.addSubview(btn)
        btn.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        btn.rightAnchor.constraint(equalTo: bottomView.rightAnchor,constant: -30).isActive = true
        btn.heightAnchor.constraint(equalToConstant:50).isActive = true
        btn.widthAnchor.constraint(equalToConstant:80).isActive = true

        view.addSubview(textFiled)
        textFiled.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        textFiled.leftAnchor.constraint(equalTo: bottomView.leftAnchor).isActive = true
        textFiled.rightAnchor.constraint(equalTo: btn.leftAnchor).isActive = true
        textFiled.heightAnchor.constraint(equalToConstant:50).isActive = true

    }
    
    @objc func sendMessage(){
        if textFiled.hasText  == false {return}
        guard let text = textFiled.text, let userId = User?.uid else {return}
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        let values = ["text":text, "tameStamp":timeStamp] as [String : Any]
        
        _ = self.setUserInfo

        FBNetworking.shared.sendMessages(text: text, userId: userId, firstSubChild: "message", secondSubChild: userId, values: values)
        
    }
    
    
    lazy var setUserInfo = {
        let currentID = String(Auth.auth().currentUser!.uid)
        let ref = Database.database().reference()
        let values = ["name":User?.name!, "profileImgUrl":User?.profileImgUrl!]
        ref.child("message").child(currentID).child((User?.uid)!).child("userInfo").setValue(values)

    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
    
    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        // Configure the cell...
//
//        return cell
//    }
//

}
