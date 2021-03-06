//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/27/20.
//

import Vapor
import Fluent

final class BlogPostModel: Model {
    static let schema = "blog_posts"
    
    struct FieldKeys {
        static var title: FieldKey { "title" }
        static var slug: FieldKey { "slug" }
        static var image: FieldKey { "image" }
        static var excerpt: FieldKey { "excerpt" }
        static var date: FieldKey { "date" }
        static var content: FieldKey { "content" }
        static var categoryId: FieldKey { "category_id" }
    }
    
    @ID() var id: UUID?
    
    @Field(key: FieldKeys.title) var title: String
    @Field(key: FieldKeys.slug) var slug: String
    @Field(key: FieldKeys.image) var image: String
    @Field(key: FieldKeys.excerpt) var excerpt: String
    @Field(key: FieldKeys.date) var date: Date
    @Field(key: FieldKeys.content) var content: String
    
    @Parent(key: FieldKeys.categoryId) var category: BlogCategoryModel
    
    convenience init(id: UUID? = nil, title: String, slug: String, image: String, excerpt: String, date: Date, content: String, categoryId: UUID) {
        self.init()
        self.id = id
        self.title = title
        self.slug = slug
        self.image = image
        self.excerpt = excerpt
        self.date = date
        self.content = content
        self.$category.id = categoryId
    }
}

extension BlogPostModel {
    // Doesn't contain sensitive info or relationship data
    struct ViewContext: Encodable {
        var id: String?
        var title: String
        var slug: String
        var image: String
        var excerpt: String
        var date: String
        var content: String
        
        init(model: BlogPostModel) {
            self.id = model.id?.uuidString
            self.title = model.title
            self.slug = model.slug
            self.image = model.image
            self.excerpt = model.excerpt
            self.date = DateFormatter.year.string(from: model.date)
            self.content = model.content
        }
    }
    
    var viewContext: ViewContext { .init(model: self) }
}
