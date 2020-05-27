//
//  Frontend.swift
//  
//
//  Created by Samantha Gatt on 5/27/20.
//

import Vapor

struct FrontendController {
    func homeView(_ req: Request) throws -> EventLoopFuture<View> {
        struct Context: Encodable {
            let title: String
            let header: String
            let message: String
        }
        let context = Context(title: "myPage - Home", header: "Hi there,", message: "Welcome to my awesome page")
        return req.view.render("home", context)
    }
}
