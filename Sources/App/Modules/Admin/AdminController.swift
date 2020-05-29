//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/29/20.
//

import Vapor

struct AdminController {
    func homeView(_ req: Request) throws -> EventLoopFuture<View> {
        struct Context: Encodable {
            let title: String
            let header: String
            let message: String
        }
        let user = try req.auth.require(UserModel.self)
        let context = Context(title: "myPage - Admin", header: "Hi \(user.email)", message: "Welcome to the CMS!")
        return req.view.render("Admin/home", context)
    }
}
