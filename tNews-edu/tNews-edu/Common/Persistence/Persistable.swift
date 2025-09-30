//
//  Persistable.swift
//  tNews-edu
//
//  Created by Nikita Terin on 28.09.2025.
//

import CoreData

protocol Persistable {
    associatedtype DBType: NSManagedObject

    static func from(_ dbModel: DBType) throws -> Self

    @discardableResult
    func createDB(in context: NSManagedObjectContext) -> DBType
}
