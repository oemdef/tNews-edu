//
//  Source+Persistable.swift
//  tNews-edu
//
//  Created by Nikita Terin on 24.09.2025.
//

import CoreData

class DBSource: NSManagedObject {
    @NSManaged var id: String?
    @NSManaged var name: String?
}

extension Source: Persistable {
    typealias DBType = DBSource

    static func from(_ dbModel: DBSource) throws -> Source {
        Source(
            id: dbModel.id,
            name: dbModel.name
        )
    }

    func createDB(in context: NSManagedObjectContext) -> DBSource {
        let dbModel = DBSource(context: context)
        dbModel.id = id
        dbModel.name = name
        return dbModel
    }
}
