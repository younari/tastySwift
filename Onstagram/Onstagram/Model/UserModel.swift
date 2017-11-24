//
//  UserModel.swift
//  Onstagram
//
//  Created by Kimkeeyun on 21/11/2017.
//  Copyright © 2017 yunari.me. All rights reserved.
//

import Foundation
import UIKit

struct UserModel {
   
    /* Required */
    var uid: String
    
    /* Optional */
    // 01. Profile Image
    var profileImgUrl: String?
    var profileImg : UIImage?
    var profileImgData : Data? {
        if let img = self.profileImg {
            return img.generateJPEGData()
        }
        return nil
    }
    
    // 02. User Info
    var nickName: String?
    var statusMessage: String?
    
    // 03. User posts
    var posts = [PostModel]()
    
    /* Initialize */
    init(uid: String){
        self.uid = uid
    }
    
    /* UserModel Method */
    // 01. addUserInfo
    mutating func addUserInfo(with snapshot: [String:Any]) {
        let imgUrl = snapshot["profile_img_url"] as? String
        self.profileImgUrl = imgUrl
        let nickName = snapshot["nickname"] as? String ?? "닉네임을 입력하세요"
        self.nickName = nickName
        let status = snapshot["status"] as? String ?? "상태 메시지를 입력하세요"
        self.statusMessage = status
       
        if let postSnapshot = snapshot["POST"] as? [String:[String:String]] {
            // tuple을 통한 PostModel 생성
            for (key,value) in postSnapshot {
                if let newpost = PostModel(with: value) {
                    var post = newpost
                    post.addKey(key: key)
                    self.posts.append(post)
                }
                
            }
        }
    }
    
}
