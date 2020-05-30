//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/28/20.
//

import Vapor
import Fluent

final class UserModel: Model, Authenticatable, SessionAuthenticatable {
    static var schema: String { "user_users" }
    
    struct FieldKeys {
        static var email: FieldKey { "email" }
        static var password: FieldKey { "password" }
        static var sessionID: FieldKey { "sessionID" }
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

// MARK: SessionAuthenticatable
extension UserModel {
    typealias SessionID = UUID
    
    // Should never be nil
    var sessionID: UUID { id! }
}
