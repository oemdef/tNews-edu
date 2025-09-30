//
//  FetchRequestFactory.swift
//  tNews-edu
//
//  Created by Nikita Terin on 28.09.2025.
//

import CoreData

final class FetchRequestFactory {

    func makeFetchRequest<Model: Persistable>(
        for modelType: Model.Type,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) -> NSFetchRequest<Model.DBType> {
        let request = NSFetchRequest<Model.DBType>(entityName: String(describing: Model.self))
        request.sortDescriptors = sortDescriptors
        request.returnsObjectsAsFaults = false
        return request
    }
}
