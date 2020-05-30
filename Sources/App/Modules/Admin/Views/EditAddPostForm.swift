//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/30/20.
//

import Vapor

struct EditAddPostForm: Form {
    
    struct Post: Decodable {
        let id: String
        let title: String
        let slug: String
        let excerpt: String
        let date: String
        let content: String
    }
    
    enum DisplayNames: String {
        case title = "Title",
             slug = "Slug",
             excerpt = "Excerpt",
             date = "Date",
             content = "Content"
    }
    
    var id: String? = nil
    var title: FormInput =
        FormInput(name: Self.CodingKeys.title.stringValue,
                  title: DisplayNames.title.rawValue)
    var slug: FormInput =
        FormInput(name: Self.CodingKeys.slug.stringValue,
                  title: DisplayNames.slug.rawValue)
    var excerpt: FormInput =
        FormInput(class: "small",
                  name: Self.CodingKeys.excerpt.stringValue,
                  title: DisplayNames.excerpt.rawValue,
                  type: "textarea")
    var content: FormInput =
        FormInput(class: "large",
                  name: Self.CodingKeys.content.stringValue,
                  title: DisplayNames.content.rawValue,
                  type: "textarea")
    var date: FormInput =
        FormInput(name: Self.CodingKeys.date.stringValue,
                  title: DisplayNames.date.rawValue,
                  requiredText: "(yyyy)")
    
    /// Array of all the input fields for Leaf
    /// - Note: Not a computed property because Leaf can't recognize them
    private(set) var fields: [FormInput] = []
    
    init() { refreshFields() }
    
    init(from req: Request) throws {
        let context = try req.content.decode(Post.self)
        if !context.id.isEmpty {
            id = context.id
        }
        title.value = context.title
        slug.value = context.slug
        excerpt.value = context.excerpt
        content.value = context.content
        date.value = context.date
        refreshFields()
    }
    
    init(from post: BlogPostModel) {
        id = post.id?.uuidString
        title.value = post.title
        slug.value = post.slug
        excerpt.value = post.excerpt
        content.value = post.content
        date.value = DateFormatter.year.string(from: post.date)
        refreshFields()
    }
    
    func createPost() -> BlogPostModel {
        let post = BlogPostModel()
        write(to: post)
        return post
    }
    func write(to post: BlogPostModel) {
        post.title = title.value
        post.slug = slug.value
        post.excerpt = excerpt.value
        post.content = content.value
        post.date = DateFormatter.year.date(from: date.value) ?? Date()
    }
    
    mutating func validate() -> Bool {
        title.error = title.value.isEmpty ? "Title is required" : nil
        slug.error = slug.value.isEmpty ? "Slug is required" : nil
        excerpt.error = excerpt.value.isEmpty ? "Excerpt is required" : nil
        content.error = content.value.isEmpty ? "Content is required" : nil
        
        let year = DateFormatter.year.date(from: date.value)
        date.error = date.value.isEmpty ? "Date is required" :
            year == nil ? "Invalid date" : nil
        
        refreshFields()
        
        if title.error == nil &&
            slug.error == nil &&
            excerpt.error == nil &&
            content.error == nil &&
            year != nil {
                return true
        } else { return false }
    }
    
    /// Should be called whenever any of the fields are updated
    ///
    /// Needed since Leaf won't recognize computed properties
    private mutating func refreshFields() {
        fields = [title, slug, excerpt, content, date]
    }
}
