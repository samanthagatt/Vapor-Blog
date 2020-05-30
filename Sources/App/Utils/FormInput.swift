//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/29/20.
//

import Foundation

protocol Form: Encodable {
    var fields: [FormInput] { get }
}

struct FormInput: Encodable {
    let `class`: String
    let name: String
    let title: String
    let type: String
    var value: String
    let requiredText: String?
    var error: String?
    
    init(class: String = "input",
         name: String,
         title: String,
         type: String = "text",
         value: String = "",
         requiredText: String? = "(required)",
         error: String? = nil) {
        
        self.class = `class`
        self.name = name
        self.title = title
        self.type = type
        self.value = value
        self.requiredText = requiredText
        self.error = error
    }
    
    static func inputsFrom(post: BlogPostModel) -> [FormInput] {
        [
            FormInput(name: BlogPostModel.FieldKeys.title.description,
                      title: "Title",
                      value: post.title),
            FormInput(name: BlogPostModel.FieldKeys.slug.description,
                      title: "Slug",
                      value: post.slug),
            FormInput(class: "small",
                      name: BlogPostModel.FieldKeys.excerpt.description,
                      title: "Excerpt",
                      type: "textarea",
                      value: post.excerpt,
                      requiredText: nil),
            FormInput(class: "large",
                      name: BlogPostModel.FieldKeys.content.description,
                      title: "Content",
                      value: post.content,
                      requiredText: nil),
            FormInput(name: BlogPostModel.FieldKeys.date.description,
                      title: "Date",
                      value: DateFormatter.year.string(from: post.date),
                      requiredText: "(yyyy)")
        ]
    }
}
