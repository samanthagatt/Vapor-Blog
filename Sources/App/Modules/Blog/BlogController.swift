//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/27/20.
//

import Vapor
import Fluent

struct BlogController {
    struct PostWithCategory: Encodable {
        let category: BlogCategoryModel.ViewContext
        let post: BlogPostModel.ViewContext
    }
    
    func blogView(req: Request) throws -> EventLoopFuture<View> {
        struct Context: Encodable {
            // Add in the relationships
            let title: String
            let items: [PostWithCategory]
        }
        // Perform the db query and return all the posts so they can be rendered
        return BlogPostModel.query(on: req.db)
            // Sort by date newest to oldest
            // $date refers to property wrapper of date (the key for it in the db)
            .sort(\.$date, .descending)
            // Include relationship too
            .with(\.$category)
            // Executes query and returns requested rows
            .all()
            // Transform each blog post model into a PostWithCategory
            .mapEach {
                PostWithCategory(category: $0.category.viewContext,
                                         post: $0.viewContext)
            // When the future is fulfilled, create the context and render the view
            }.flatMap { posts in
                let context = Context(title: "myProject - Blog", items: posts)
                return req.view.render("Blog/blog", context)
            }
    }
    func postView(req: Request) throws -> EventLoopFuture<Response> {
        struct Context: Encodable {
            let title: String
            let item: PostWithCategory
        }
        
        req.logger.debug("Path!!\n\(req.url.path)")
        let slug = req.url.path.trimmingCharacters(in: .init(charactersIn: "/"))
        req.logger.debug("Slug!!\n\(slug)")
        
        return BlogPostModel.query(on: req.db)
            // Makes sure only blog posts with the same slug are inclueded in query
            .filter(\.$slug == slug)
            // Includes category relationship
            .with(\.$category)
            // Performs query and returns only the first result (if there is any)
            .first()
            // Once the query is done
            .flatMap { post in
                // Makes sure a post was found
                guard let post = post else {
                    // No post was found with the specified slug
                    // So redirect to home page
                    // Returning a response as a future that's already been fulfilled (not pending or rejected)
                    return req.eventLoop.future(req.redirect(to: "/"))
                }
                let item = PostWithCategory(category: post.category.viewContext, post: post.viewContext)
                let context = Context(title: "myProject - \(post.title)", item: item)
                return req.view.render("Blog/post", context).encodeResponse(for: req)
            }
    }
}
