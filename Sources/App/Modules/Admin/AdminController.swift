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
    func postsView(_ req: Request) throws -> EventLoopFuture<View> {
        struct Context: Encodable {
            let list: [BlogPostModel.ViewContext]
        }
        return BlogPostModel.query(on: req.db)
            .all()
            .mapEach(\.viewContext)
            .flatMap { posts in
                req.view.render("Admin/postsTable", Context(list: posts))
            }
    }
    func addPostView(_ req: Request) throws -> EventLoopFuture<View> {
        return req.view.render("Admin/editAddPost", EditAddPostForm())
    }
    func create(_ req: Request) throws -> EventLoopFuture<Response> {
        let form = try EditAddPostForm(from: req)
        let model = BlogPostModel()
        // Set default image
        model.image = "/images/posts/01.jpg"
        form.write(to: model)
        // Set default category
        return BlogCategoryModel.query(on: req.db)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                // category.id should never be nil
                model.$category.id = category.id ?? UUID()
                return model.create(on: req.db)
            }.map {
                req.redirect(to: "/admin/posts")
            }
    }
}
