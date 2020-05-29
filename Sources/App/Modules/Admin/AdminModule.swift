//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/29/20.
//

import Vapor

struct AdminModule: Module {
    var router: RouteCollection? { AdminRouter() }
}
