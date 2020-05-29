//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/28/20.
//

import Vapor

struct UserController {
    func loginView(req: Request) -> EventLoopFuture<View> {
        struct Context: Encodable {
            let title: String
        }
        let context = Context(title: "myProject - Sign in")
        return req.view.render("User/login", context)
    }
    func login(req: Request) throws -> Response {
        // UserCredentialsAuthenticator middlewear is applied to the route that uses this fn
        // So user should be signed in by this time
        // Gets signed in user
        guard let user = req.auth.get(UserModel.self) else {
            throw Abort(.unauthorized)
        }
        req.session.authenticate(user)
        return req.redirect(to: "/")
    }
    func logout(req: Request) throws -> Response {
        req.auth.logout(UserModel.self)
        req.logger.info("Unauthenticating!!!")
        req.session.unauthenticate(UserModel.self)
        return req.redirect(to: "/")
    }
}
