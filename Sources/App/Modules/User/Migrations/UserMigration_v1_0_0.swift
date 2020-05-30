//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/28/20.
//

import Fluent

struct UserMigration_v1_0_0: Migration {
    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(UserModel.schema)
                .id()
                .field(UserModel.FieldKeys.email, .string, .required)
                .field(UserModel.FieldKeys.password, .string, .required)
                .unique(on: UserModel.FieldKeys.email)
                .create()
            ]).flatMap {
                UserSeed_v1_0_0().users().create(on: db)
            }
    }
    
    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(UserModel.schema).delete()
        ])
    }
}
