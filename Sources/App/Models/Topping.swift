import Vapor
import Fluent

final class Topping:Model, Content, Codable {
    static let schema = "toppings"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String

    @Field(key: "description")
    var description: String

    @Field(key: "image_featured")
    var image_featured: String
    
    @Field(key: "price")
    var price: Float
    
    init() { }
    
    init(id: UUID? = nil, title: String, description: String, image_featured: String, price: Float) {
        self.id = id
        self.title = title
        self.description = description
        self.image_featured = image_featured
        self.price = price
    }
}

final class ToppingUpdate:Content, Codable{
    var title: String?
    var description: String?
    var image_featured: String?
    var price: Float?
    
    init(title: String?, description: String?, image_featured: String?, price: Float?) {
        self.title = title
        self.description = description
        self.image_featured = image_featured
        self.price = price
    }
}

final class ToppingLanding: Content, Codable {
    var title: String

    init(title: String) {
        self.title = title
    }
}