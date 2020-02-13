//
//  MessageController+handleers.swift
//  Chatdemo
//
//  Created by Lucas on 9/13/19.
//  Copyright © 2019 Lucas. All rights reserved.
//

import UIKit
import Firebase

extension MessageController{
    
    @objc func handleMessage(){
        self.navigationController?.pushViewController(NewMessageController(), animated: true)
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            //            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            handleLogout()
        }else{
            fetchUserAndSetupNavBarTitle()
            fetchAllUersMessage()

        }
        
    }
    
    func fetchUserAndSetupNavBarTitle(){
        FBNetworking.shared.fetchUserSingleEvent(webType: .observeSingleEvent, subChild: "users") {[weak self] (dict, nil) in
            
            guard let dict = dict else {return}
            let user = UserModel()
            user.setValuesForKeys(dict)
            self?.setupNavBarWithUser(user: user)
        }
        
    
    }
    
    
    
    
    func setupNavBarWithUser(user:UserModel){
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImg = UIImageView()
        profileImg.contentMode = .scaleAspectFill
        profileImg.layer.cornerRadius = 20
        profileImg.layer.masksToBounds = true
        if let profileImgUrl = user.profileImgUrl{
            profileImg.loadingImgUsingCatchWithUrlString(url:profileImgUrl)
        }
        
        let name = UILabel()
        name.text = user.name
        name.numberOfLines = 1
        
        
        //ios
        containerView.addSubview(profileImg)
        profileImg.translatesAutoresizingMaskIntoConstraints = false
        profileImg.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImg.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImg.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImg.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.leftAnchor.constraint(equalTo:profileImg.rightAnchor, constant: 8).isActive = true
        name.rightAnchor.constraint(equalTo:containerView.rightAnchor).isActive = true
        name.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        name.heightAnchor.constraint(equalTo: profileImg.heightAnchor).isActive = true
        
        
        self.navigationItem.title = user.name
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        self.navigationController?.navigationBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushToChatController)))
        
        
        
    }
    
    @objc func pushToChatController(){
        if navigationItem.title == ""{return}
        let view = ChatLogController()
        navigationController?.pushViewController(view, animated: true)
        
    }
    @objc func handleLogout(){
        
        navigationItem.titleView = UIView()
        do {
            try Auth.auth().signOut()
            
        } catch let err {
            print(err.localizedDescription)
        }
        let controller = UINavigationController(rootViewController: LoginViewController())
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }

}
