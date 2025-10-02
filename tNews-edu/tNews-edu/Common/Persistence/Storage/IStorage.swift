//
//  IStorage.swift
//  tNews-edu
//
//  Created by Nikita Terin on 28.09.2025.
//

import CoreData

protocol IStorage {
    func fetch<Model: Persistable>(
        _ modelType: Model.Type,
        sortDescriptors: [NSSortDescriptor]?
    ) -> [Model]

    func replaceAll<Model: Persistable>(_ objects: [Model])
}

extension IStorage {
    func fetch<Model: Persistable>(_ modelType: Model.Type) -> [Model] {
        fetch(modelType, sortDescriptors: nil)
    }
}
