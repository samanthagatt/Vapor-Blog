import Fluent
import Vapor

func routes(_ app: Application) throws {
    let routers: [RouteCollection] = [
        FrontendRouter(),
        BlogRouter()
    ]
    for router in routers {
        try router.boot(routes: app.routes)
    }
}
