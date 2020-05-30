//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/29/20.
//

import Vapor

struct AdminController { }

// MARK: Views
extension AdminController {
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
    func editPostView(_ req: Request) throws -> EventLoopFuture<View> {
        // Finding a post returns a future post model so you have to wait
        // until it's fulfilled (inside flatMap) to render the view
        try findPost(on: req).flatMap { post in
            let form = EditAddPostForm(from: post)
            return req.view.render("Admin/editAddPost", form)
        }
    }
}

// MARK: Private methods
extension AdminController {
    private func findPost(on req: Request) throws -> EventLoopFuture<BlogPostModel> {
        guard let uuidString = req.parameters.get("id"),
            let uuid = UUID(uuidString: uuidString) else {
                throw Abort(.badRequest)
        }
        return BlogPostModel.find(uuid, on: req.db).unwrap(or: Abort(.notFound))
    }
}

// MARK: Requests
extension AdminController {
    func create(_ req: Request) throws -> EventLoopFuture<Response> {
        var form = try EditAddPostForm(from: req)
        // Make sure valid information was added and set errors if not
        guard form.validate() else {
            // Rerender page with upadated form with errors
            return req.view.render("Admin/editAddPost", form)
                .encodeResponse(for: req)
        }
        // Create
        let post = form.createPost()
        // Set default image
        post.image = "/images/posts/01.jpg"
        // Set default category
        return BlogCategoryModel.query(on: req.db)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                // category.id should never be nil
                post.$category.id = category.id ?? UUID()
                return post.create(on: req.db)
            }.map {
                // Id should not be nil since post was already created
                guard let id = post.id else {
                    // Redirect to all blog posts if it is
                    return req.redirect(to: "blog")
                }
                // Redirect to new posts page
                return req.redirect(to: id.uuidString)
            }
    }
    func editPost(_ req: Request) throws -> EventLoopFuture<Response> {
        // Decode body of req into BlogPostModel and create a form from it
        var form = try EditAddPostForm(from: req)
        guard form.validate() else {
            // Rerender view with errors if form isn't valid
            return req.view.render("Admin/editAddPost", form)
                .encodeResponse(for: req)
        }
        // Find post by the id parameter in the req path
        return try findPost(on: req).flatMap { post in
            // Update post
            form.write(to: post)
            // Save post to db
            return post.update(on: req.db)
        // Wait until save is done (future is resolved)
        }.map {
            // Redirect to post's page (will be updated now)
            return req.redirect(to: "/\(form.slug.value)")
        }
    }
}
