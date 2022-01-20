import Foundation

extension Array where Element: Equatable {

    func maybeRemoveRandomElement() -> [Element] {
        let should = Bool.random()
        guard should, let element = randomElement(), let index = firstIndex(of: element) else {
            return self
        }
        var myself = self
        myself.remove(at: index)
        return myself
    }
}
