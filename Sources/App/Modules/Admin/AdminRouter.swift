//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/29/20.
//

import Vapor

struct AdminRouter: RouteCollection {
    let controller = AdminController()
    
    func boot(routes: RoutesBuilder) throws {
        routes.grouped([
                UserSessionAuthenticator(),
                // Checks req.auth storage and redirects to "/" if unauthorized
                UserModel.redirectMiddleware(path: "/")
            ])
            .get("admin", use: controller.homeView)
        routes.grouped([
                UserSessionAuthenticator(),
                UserModel.redirectMiddleware(path: "/")
            ])
            .grouped("admin")
            .get("posts", use: controller.postTabelView)
    }
}
