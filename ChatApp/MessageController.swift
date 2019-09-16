//
//  ViewController.swift
//  LChatApp
//
//  Created by Lucas on 9/10/19.
//  Copyright © 2019 Lucas. All rights reserved.
//

import UIKit
import Firebase
class MessageController: UITableViewController {

    let MessageID = "Messageid"
    var messageList = [UserModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(handleMessage))

        tableView.register(UINib(nibName: "HomeMessageCell", bundle: nil), forCellReuseIdentifier: MessageID)

        tableView.tableFooterView = UIView()
        checkIfUserIsLoggedIn()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageID, for: indexPath) as! HomeMessageCell

        cell.model = self.messageList[indexPath.row]
        
        cell.lbltime.text = self.messageList[indexPath.row].time
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatView = ChatLogController()
        chatView.User = messageList[indexPath.row]
        navigationController?.pushViewController(chatView, animated: true)
    }
    
    
    
    func fetchAllUersMessage(){
        
        FBNetworking.shared.observeMessages(userId: "", firstSubChild: "message", webType: .fetchMessageFromAll) {[weak self] (data, err) in
            //data is all user'list
            guard let data = data else {return}
//            var dict = [String:Any]()
            for(key,value) in data{
                let k = value as! [String:Any]
                let item = k["userInfo"] as! [String:AnyObject]
                let user = UserModel()
                user.setValuesForKeys(item)
                self?.messageList.append(user)
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            }
        }
        
    }
    
    
    




