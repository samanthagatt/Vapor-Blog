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
        // Use UserModel.redirectMiddleware(path:) in AdminRouter instead
        // let user = try req.auth.require(UserModel.self)
        let user = req.auth.get(UserModel.self)
        let context = Context(title: "myPage - Admin", header: "Hi \(user?.email ?? "")", message: "Welcome to the CMS!")
        return req.view.render("Admin/home", context)
    }
    func postTabelView(_ req: Request) throws -> EventLoopFuture<View> {
        struct Context: Encodable {
            let list: [BlogPostModel.ViewContext]
        }
        return BlogPostModel.query(on: req.db)
            .all()
            .mapEach(\.viewContext)
            .flatMap { posts in
                req.view.render("Admin/postTable", Context(list: posts))
            }
    }
}
