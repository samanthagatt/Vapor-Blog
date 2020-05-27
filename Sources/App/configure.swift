import Vapor
import Leaf

// Called before your application initializes.
public func configure(_ app: Application) throws {
    // Serves files from `Public/` directory
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // Tell app to use leaf templating engine to render views
    app.views.use(.leaf)
    // Cache-ing requires you to restart the server to see changes in leaf files
    app.leaf.cache.isEnabled = app.environment.isRelease
    
    try routes(app)
}
