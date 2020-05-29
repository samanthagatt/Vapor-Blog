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
    
    let workingDir = app.directory.workingDirectory
    app.leaf.configuration.rootDirectory = "/"
    // Uses custom file naming system
    app.leaf.files = ModularViewFiles(workingDir: workingDir, fileio: app.fileio)
    
    // Sets up sessions to use fluent
    app.sessions.use(.fluent)
    // Adds fluent default migration ("_fluent_sessions" table)
    app.migrations.add(SessionRecord.migration)
    // Adds sessions middleware
    // Will try to load session data from session cookie stored locally on client side
    // Session cookie simply stores session identifier with no additional data
    // Rest of data is stored in "_fluent_sessions" table here on the server
    app.middleware.use(app.sessions.middleware)
    
    let modules: [Module] = [
        FrontendModule(),
        BlogModule(),
        UserModule(),
        AdminModule(),
    ]
    for module in modules {
        try module.configure(app)
    }
}
