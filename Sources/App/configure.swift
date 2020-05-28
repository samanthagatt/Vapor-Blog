import Vapor
import Leaf
import Fluent
import FluentSQLiteDriver

// Called before your application initializes.
public func configure(_ app: Application) throws {
    // Serves files from `Public/` directory
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // Tell database to store data in file called db.sqlite
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    
    // Tell app to use leaf templating engine to render views
    app.views.use(.leaf)
    // Cache-ing requires you to restart the server to see changes in leaf files
    app.leaf.cache.isEnabled = app.environment.isRelease
    
    let modules: [Module] = [
        FrontendModule(),
        BlogModule()
    ]
    for module in modules {
        try module.configure(app)
    }
}
