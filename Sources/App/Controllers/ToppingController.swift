import Vapor
import Fluent

struct ToppingController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let userMiddleware = UserAuthMiddleware()
        let midUserAuthMiddleware = MidUserAuthMiddleware()
        let toppings = routes.grouped("topping")
        let toppingAuthUser = toppings.grouped(userMiddleware)
        let _ = toppings.grouped(midUserAuthMiddleware)

        routes.get( use: getLanding)

        toppingAuthUser.get(use: getAllHandler)
        toppingAuthUser.post(use: createHandler)   
        toppingAuthUser.get(":topping_id", use: getOneHandler)
        toppingAuthUser.put(":topping_id", use: updateOneHandler)
    }

    func getLanding(_ req: Request) throws -> EventLoopFuture<ToppingLanding> {
        let landing = ToppingLanding(title: NSLocalizedString("Topping Api Microservices", comment: ""))
        return req.eventLoop.future(landing)
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Topping]> {
        return Topping.query(on: req.db).all()
    }

    func createHandler(_ req: Request) throws -> EventLoopFuture<Topping> {
        let item = try req.content.decode(Topping.self)
        return item.save(on: req.db).map { item }
    }

    func getOneHandler(_ req: Request) throws -> EventLoopFuture<Topping> {
        return Topping.find(req.parameters.get("item_id"), on: req.db)
                .unwrap(or: Abort(.notFound))
    }

    func updateOneHandler(_ req: Request) throws -> EventLoopFuture<Topping> {
        let toppingUpdate = try req.content.decode(ToppingUpdate.self)

        return Topping.find(req.parameters.get("item_id"), on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { topping in
                    
                    topping.title = toppingUpdate.title ?? topping.title
                    topping.description = toppingUpdate.description ?? topping.description
                    topping.image_featured = toppingUpdate.image_featured ?? topping.image_featured
                    topping.price = toppingUpdate.price ?? topping.price

                    return topping.update(on: req.db).map { topping }
                }
    }
}