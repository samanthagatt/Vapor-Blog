//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/27/20.
//

import Vapor

struct BlogController {
    func blogView(req: Request) throws -> EventLoopFuture<View> {
        struct Context: Encodable {
            let title: String
            let posts: [BlogPost]
        }
        let posts = BlogRepository().publishedPosts()
        let context = Context(title: "myProject - Blog", posts: posts)
        return req.view.render("blog", context)
    }
    func postView(req: Request) throws -> EventLoopFuture<Response> {
        let posts = BlogRepository().publishedPosts()
        
        print("Path!!:\n\(req.url.path)")
        let slug = req.url.path.trimmingCharacters(in: .init(charactersIn: "/"))
        print("Slug!!:\n\(slug)")
        
        guard let post = posts.first(where: { $0.slug == slug }) else {
            // Returning a response as a future that's already been fulfilled (not pending or rejected)
            return req.eventLoop.future(req.redirect(to: "/"))
        }
        struct Context: Encodable {
            let title: String
            let post: BlogPost
        }
        let context = Context(title: "myPage", post: post)
        // Need to convert it into a response instead of a view since if it can't find the post
        // We redirected early (which is a response not a view)
        return req.view.render("post", context).encodeResponse(for: req)
    }
}
