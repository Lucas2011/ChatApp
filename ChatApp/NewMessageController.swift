//
//  NewMessageController.swift
//  Chatdemo
//
//  Created by Lucas on 9/11/19.
//  Copyright © 2019 Lucas. All rights reserved.
//

import UIKit
import Firebase



class NewMessageController: UITableViewController {
    

    let cellID = "NewMessageCell"

    var userList = [UserModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cencel", style: .plain, target: self, action:#selector(handleCancel))

        
        tableView.register(UINib(nibName: "NewMessageCell", bundle: nil), forCellReuseIdentifier: cellID)
        fetchUsers()
      
    }

    func fetchUsers(){
        
        FBNetworking.shared.fetchUserSingleEvent(webType: .observeAllUsers, subChild: "users") {[weak self] (data, err) in
            guard let dict = data else {return}
            for (key,value) in dict{
                var item  = value as! [String:Any]
                item.updateValue(key, forKey: "uid")
                let user = UserModel()
                user.setValuesForKeys(item)
                self?.userList.append(user)
                
            }
            
            //testing 
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NewMessageCell
        cell.lbnName.text = userList[indexPath.row].name
        cell.lbnEmail.text = userList[indexPath.row].email
        cell.profileIMG.loadingImgUsingCatchWithUrlString(url: userList[indexPath.row].profileImgUrl!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatView = ChatLogController()
        chatView.modalPresentationStyle = .fullScreen
        chatView.User = userList[indexPath.row]
        navigationController?.pushViewController(chatView, animated: true)
    }

}
