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
        let protected = routes.grouped([
            UserSessionAuthenticator(),
            UserModel.redirectMiddleware(path: "/")
        ])
        
        let admin = protected.grouped("admin")
        admin.get(use: controller.homeView)
        
        let posts = admin.grouped("posts")
        posts.get(use: controller.postsView)
        posts.get("new", use: controller.addPostView)
        posts.post("new", use: controller.create)
        
        let post = posts.grouped(":id")
        post.get(use: controller.editPostView)
        post.post(use: controller.editPost)
        
        post.post("delete", use: controller.deletePost)
    }
}
