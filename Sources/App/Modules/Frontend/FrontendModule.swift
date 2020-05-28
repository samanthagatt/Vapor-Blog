//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/28/20.
//

import Vapor

struct FrontendModule: Module {
    var router: RouteCollection? { FrontendRouter() }
}
