//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/27/20.
//

import Foundation
import Fluent

struct BlogMigration_v1_0_0: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // .flatten() lets you create multiple schemas at once
        database.eventLoop.flatten([
            
            // Creates Blog Category Model schema
            database.schema(BlogCategoryModel.schema)
                // Makes sure it has a unique id for each entry
                .id()
                // Adds title field, of type string, that's required
                .field(BlogCategoryModel.FieldKeys.title, .string, .required)
                // Creates schema
                .create(),
            
            database.schema(BlogPostModel.schema)
                .id()
                .field(BlogPostModel.FieldKeys.title, .string, .required)
                .field(BlogPostModel.FieldKeys.slug, .string, .required)
                .field(BlogPostModel.FieldKeys.image, .string, .required)
                .field(BlogPostModel.FieldKeys.excerpt, .string, .required)
                .field(BlogPostModel.FieldKeys.date, .datetime, .required)
                .field(BlogPostModel.FieldKeys.content, .string, .required)
                // Not required (can be null)
                .field(BlogPostModel.FieldKeys.categoryId, .uuid)
                // Creates relationship to category
                .foreignKey(BlogPostModel.FieldKeys.categoryId,
                            // Refrencing category schema
                            references: BlogCategoryModel.schema,
                            .id,
                            // If the corresponding category gets deleted
                            // set the categoryId property to null
                            onDelete: DatabaseSchema.ForeignKeyAction.setNull,
                            onUpdate: .cascade)
                // Specifies that slug is unique
                .unique(on: BlogPostModel.FieldKeys.slug)
                .create()
        // Seeds db with starting data
        ]).flatMap {
            // Creates category models
            let defaultCategory = BlogCategoryModel(title: "Uncategorized")
            let islandCategory = BlogCategoryModel(title: "Islands")
            return [defaultCategory, islandCategory]
                // Adds them in the database
                .create(on: database)
                // Once the future returned by .create() is fullfilled,
                // create blog posts and add them to db
                .flatMap { [unowned defaultCategory] in
                    // Creates blog post models
                    let posts = BlogSeed_v1_0_0().uncategorizedPosts(for: defaultCategory) + BlogSeed_v1_0_0().islandPosts(for: islandCategory)
                    // Adds them to the database
                    return posts.create(on: database)
            }
        }
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        // deletes all schemas when database is reverted
        database.eventLoop.flatten([
            database.schema(BlogCategoryModel.schema).delete(),
            database.schema(BlogPostModel.schema).delete()
        ])
    }
}
