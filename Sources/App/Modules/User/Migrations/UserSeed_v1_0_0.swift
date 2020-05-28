//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/28/20.
//

import Vapor

struct UserSeed_v1_0_0 {
    func users() -> [UserModel] {
        guard let pword = try? Bcrypt.hash("ChangeMe") else { return [] }
        return [
            UserModel(email: "smfgatt@gmail.com", password: pword)
        ]
    }
}
