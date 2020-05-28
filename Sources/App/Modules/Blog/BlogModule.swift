//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/28/20.
//

import Vapor
import Fluent

struct BlogModule: Module {
    var router: RouteCollection? { BlogRouter() }
    var migrations: [Migration] { [BlogMigration_v1_0_0()] }
}
