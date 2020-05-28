//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/28/20.
//

import Vapor

struct UserRouter: RouteCollection {
    let controller = UserController()
    
    func boot(routes: RoutesBuilder) throws {
        
    }
}
