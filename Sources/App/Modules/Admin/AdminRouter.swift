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
        routes.grouped(UserSessionAuthenticator())
            .get("admin", use: controller.homeView)
    }
}
