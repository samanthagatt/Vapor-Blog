//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/27/20.
//

import Vapor

struct FrontendRouter: RouteCollection {
    let controller = FrontendController()
    func boot(routes: RoutesBuilder) throws {
        // Applies sessions middleware
        routes.grouped(UserSessionAuthenticator())
            .get(use: controller.homeView)
    }
}
