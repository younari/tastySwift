//
//  UserService.swift
//  1018_Fanxy
//
//  Created by 김기윤 on 18/10/2017.
//  Copyright © 2017 younari. All rights reserved.
//

import Foundation


struct UserService {
    
    static var sharedInstance: UserService = UserService()
    var model: Users?
    var documentDirectory: URL {
        get {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
    }
    
    init() {
        // plist -> Model
        loadData()
    }

    mutating func loadData() {
        // documentDirectory까지의 경로
        let dataURL = documentDirectory.appendingPathComponent("UserData.plist")

        let dataStrPath = dataURL.path
        print(dataStrPath)
        if !FileManager.default.fileExists(atPath: dataStrPath) {
            guard let plistURL = Bundle.main.url(forResource: "UserData", withExtension: "plist") else { return }
            try! FileManager.default.copyItem(at: plistURL, to: dataURL) // 오류를 던질 수 있으므로 try! (에러 무시)
        }
        
        let propertyDecoder = PropertyListDecoder()
        let data = try! Data(contentsOf: dataURL)
        self.model = try! propertyDecoder.decode(Users.self, from: data)
        
        
    }
    
    func validateUserInfo(username:String, password: String) -> Bool {
        if let model = self.model {
            for user in model.users {
                if user.username == username && user.password == password {
                    return true
                }
            }
        }
        return false
    }
    
}