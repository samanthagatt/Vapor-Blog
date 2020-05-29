//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/28/20.
//

import Vapor
import Fluent

// RequestAuthenticator:
// Authenticator's use the incoming request to check for authentication information.
// If valid authentication credentials are present, the authenticated user is added to `req.auth`.

// CredentialsAuthenticator (conforms to RequestAuthenticator protocol):
// Helper for creating authentication middleware using request body contents.
struct UserCredentialsAuthenticator: CredentialsAuthenticator {
    struct Input: Content {
        let email: String
        let password: String
    }
    typealias Credentials = Input
    
    func authenticate(credentials: Input, for req: Request) -> EventLoopFuture<Void> {
        // Makes a query for the first user in the db with the same email
        UserModel.query(on: req.db)
            .filter(\.$email == credentials.email)
            .first()
            .map { user in
                // Make sure user is not nil and verify the password used is correct
                if let user = user,
                    let verified = try? Bcrypt.verify(credentials.password, created: user.password),
                    verified {
                    // Login the user
                    req.auth.login(user)
                }
            }
    }
}
