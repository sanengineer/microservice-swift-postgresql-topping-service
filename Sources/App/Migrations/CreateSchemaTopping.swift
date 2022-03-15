import FluentSQL

struct CreateSchemaTopping: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("toppings")
            .id()
            .field("title", .sql(raw: "VARCHAR(50)"), .required)
            .field("price", .float, .required)
            .field("description", .string, .required)
            .field("image_featured", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("toppings").delete()
    }
}