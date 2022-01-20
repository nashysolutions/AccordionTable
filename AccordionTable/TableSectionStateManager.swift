import Foundation
import OrderedCollections

final class TableSectionStateManager<Section: Hashable> {
    
    private var bank = Bank<Section>()
    
    var sectionExists: (Section) -> Bool = { _ in return false }
    
    var collapsedSections: [Section] {
        bank.sections(.collapsed)
    }
    
    func visibility(of section: Section) -> SectionVisibility {
        bank.value(for: section)
    }
    
    func update(_ section: Section, visibility: SectionVisibility) {
        bank.setValue(visibility, for: section)
    }
    
    func clean() {
        for section in bank.sections {
            if sectionExists(section) == false {
                bank.removeValue(for: section)
            }
        }
    }
}

private extension TableSectionStateManager {
    
    final class Bank<Section: Hashable>: KeyValueStorageBacked {
        
        let defaultValue: SectionVisibility = .expanded
        
        var storage: [Section: SectionVisibility] = [:]
        
        var sections: [Section] {
            storage.keys.map { $0 }
        }
        
        func sections(_ visibility: SectionVisibility) -> [Section] {
            storage.filter { (_, value: SectionVisibility) in
                value == visibility
            }.keys.map { $0 }
        }
    }
}

private protocol KeyValueStorageBacked {
    associatedtype Key: Hashable
    associatedtype Value
    var defaultValue: Value { get }
    var storage: [Key: Value] { get set }
}

extension KeyValueStorageBacked {
    
    func value(for key: Key) -> Value {
        storage[key] ?? defaultValue
    }
    
    mutating func setValue(_ value: Value, for key: Key) {
        storage[key] = value
    }
    
    mutating func removeValue(for key: Key) {
        storage[key] = nil
    }
}
