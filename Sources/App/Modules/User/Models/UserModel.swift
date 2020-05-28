//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/28/20.
//

import Foundation
import Fluent

final class UserModel: Model {
    static var schema: String { "user_users" }
    
    struct FieldKeys {
        static var email: FieldKey { "email" }
        static var password: FieldKey { "password" }
    }
    
    @ID() var id: UUID?
    @Field(key: FieldKeys.email) var email: String
    @Field(key: FieldKeys.password) var password: String
    
    convenience init(id: UserModel.IDValue? = nil, email: String, password: String) {
        self.init()
        self.id = id
        self.email = email
        self.password = password
    }
}
