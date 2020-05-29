//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/28/20.
//

import Vapor

struct UserRouter: RouteCollection {
    let controller = UserController()
    
    func boot(routes: RoutesBuilder) throws {
        routes.get("sign-in", use: controller.loginView)
        // Applies middlewear to sign-in route
        routes.grouped(UserCredentialsAuthenticator())
            .post("sign-in", use: controller.login)
        // Applies middlewear to logout route
        routes.grouped(UserSessionAuthenticator())
            .get("logout", use: controller.logout)
    }
}
