//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/27/20.
//

import Vapor

struct BlogRouter: RouteCollection {
    let controller = BlogController()
    func boot(routes: RoutesBuilder) throws {
        routes.get("blog", use: controller.blogView)
        routes.get(.anything, use: controller.postView)
    }
}
