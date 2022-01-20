import Foundation

struct DataLoader {
    
    static func originalData() throws -> Collection {
        var collection = Collection()
        let foods = ModelBuilder.makeFoods()
        for food in foods {
            collection[food] = food.items
        }
        return collection
    }
    
    static func randomSample() throws -> Collection {
        var collection = Collection()
        let foods = ModelBuilder.makeFoods().maybeRemoveRandomElement()
        for food in foods {
            collection[food] = food.items.maybeRemoveRandomElement()
        }
        return collection
    }
}

private struct ModelBuilder {
    
    static func makeFoods() -> [Food] {
        [makeFruit(), makeMeats(), makeVegetables()]
    }
    
    private static func makeFruit() -> Food {
        let items = [
            Item(title: "Banana"),
            Item(title: "Cherry"),
            Item(title: "Kiwi"),
            Item(title: "Grape")
        ]
        return Food(title: "Fruit", items: items)
    }
    
    private static func makeMeats() -> Food {
        let items = [
            Item(title: "Lamb"),
            Item(title: "Chicken"),
            Item(title: "Beef")
        ]
        return Food(title: "Meats", items: items)
    }
    
    private static func makeVegetables() -> Food {
        let items = [
            Item(title: "Cabbage"),
            Item(title: "Carrot"),
            Item(title: "Pea"),
            Item(title: "Asparagus"),
            Item(title: "Courgette")
        ]
        return Food(title: "Vegetables", items: items)
    }
}
