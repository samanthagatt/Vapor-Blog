//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/27/20.
//

import Vapor
import Fluent

final class BlogCategoryModel: Model {
    static let schema = "blog_categories"
    
    struct FieldKeys {
        static var title: FieldKey = "title"
    }
    
    @ID() var id: UUID?
    @Field(key: FieldKeys.title) var title: String
    @Children(for: \.$category) var posts: [BlogPostModel]
    
    convenience init(id: UUID? = nil, title: String) {
        self.init()
        self.id = id
        self.title = title
    }
}

extension BlogCategoryModel {
    /// Used to display data, should not contain any sensitive info
    struct ViewContext: Encodable {
        var id: String?
        var title: String
        
        init(model: BlogCategoryModel) {
            self.id = model.id?.uuidString
            self.title = model.title
        }
    }
    
    var viewContext: ViewContext { .init(model: self) }
}
