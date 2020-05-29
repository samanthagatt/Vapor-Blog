//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/28/20.
//

import Vapor

struct UserSessionAuthenticator: SessionAuthenticator {
    typealias User = UserModel
    
    func authenticate(sessionID: UUID, for req: Request) -> EventLoopFuture<Void> {
        // Makes a db query for User with id of sessionID
        User.find(sessionID, on: req.db).map { user in
            // Logs the user in if a user was found
            if let user = user {
                req.auth.login(user)
            }
        }
    }
}
