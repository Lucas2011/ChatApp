//
//  FBNetworking.swift
//  Chatdemo
//
//  Created by Lucas on 9/13/19.
//  Copyright © 2019 Lucas. All rights reserved.
//

import Foundation
import Firebase



class FBNetworking {
    enum key {
        case name
        case other
        
    }
    enum webType {
        case observeSingleEvent
        case observeAllEvents
        case observeAllUsers
        case post
        case fetchMessageFromOne
        case fetchMessageFromAll

    }
    static let shared = FBNetworking ()
    
    typealias WebResponse = ([String:Any]?,Error?)->()
    
    func fetchUserSingleEvent(webType:webType,subChild:String,completion:@escaping WebResponse){
        
        let uid = String(Auth.auth().currentUser!.uid)
        let ref = Database.database().reference()

        switch webType {
            
        case .observeSingleEvent:
            ref.child(subChild).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if var dataArry = snapshot.value as? [String:Any]{
                    dataArry.updateValue(snapshot.key, forKey: "key")
                    completion(dataArry,nil)
                }else if let dataDcit = snapshot.value as? [String:Any]{
                    completion(dataDcit,nil)}
            }, withCancel: nil)

            break
        case .observeAllUsers:
            ref.child(subChild).observeSingleEvent(of: .value, with: {(snapshot) in
                if let dict = snapshot.value as? [String:Any]{
                    completion(dict,nil)
                }
                }, withCancel: nil)
            break
        default:
            break
        }
    }

    
    
    func registerUsersI(subChild:String,uid:String,values:[String:Any],completion:@escaping WebResponse){
        let ref = Database.database().reference()
        let userReference = ref.child(subChild).child(uid)
        userReference.setValue(values, withCompletionBlock: {  (err, res) in
            
            if err != nil{
                completion(nil,err)
                return
            }
        })
    }
    
    
    func observeMessages(userId:String,firstSubChild:String,webType:webType,completion:@escaping WebResponse){
        
        let currentID = String(Auth.auth().currentUser!.uid)
        let ref = Database.database().reference()
        
        switch webType {
        case .fetchMessageFromOne:
            ref.child(firstSubChild).child(currentID).child(userId).observe(.value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject]{
                    completion(dict,nil)
                }
            }, withCancel: nil)
            break
        case .fetchMessageFromAll:
            ref.child(firstSubChild).child(currentID).observe(.value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject]{
                    completion(dict,nil)
                }
            }, withCancel: nil)

        default:
            break
        }
    }

    func sendMessages(text:String,userId:String,firstSubChild:String,secondSubChild:String,
                         values:[String:Any]){
        let currentID = String(Auth.auth().currentUser!.uid)
        let ref = Database.database().reference()
        ref.child(firstSubChild).child(currentID).child(userId).childByAutoId().setValue(values)
        }
    

    
    
    
    
}

extension Dictionary where Key == String{
    func toAttributedStringKeys() -> [NSAttributedString.Key: Value] {
        return Dictionary<NSAttributedString.Key, Value>(uniqueKeysWithValues: map {
            key, value in (NSAttributedString.Key(key), value)
        })
    }
}
