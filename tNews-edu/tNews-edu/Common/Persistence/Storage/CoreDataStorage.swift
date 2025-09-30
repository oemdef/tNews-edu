//
//  CoreDataStorage.swift
//  tNews-edu
//
//  Created by Nikita Terin on 28.09.2025.
//

import CoreData

final class CoreDataStorage: IStorage {

    private let requestFactory: FetchRequestFactory

    // Create a persistent container as a lazy variable to defer instantiation until its first use.
    private lazy var persistentContainer: NSPersistentContainer = {

        // Pass the data model filename to the container’s initializer.
        let container = NSPersistentContainer(name: "tNews-edu")

        // Load any persistent stores, which creates a store if none exists.
        container.loadPersistentStores { _, error in
            if let error {
                // Handle the error appropriately. However, it's useful to use
                // `fatalError(_:file:line:)` during development.
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()

    private lazy var backgroundContext: NSManagedObjectContext = {
        persistentContainer.newBackgroundContext()
    }()

    init(requestFactory: FetchRequestFactory) {
        self.requestFactory = requestFactory
    }

    func fetch<Model: Persistable>(
        _ modelType: Model.Type,
        sortDescriptors: [NSSortDescriptor]?
    ) -> [Model] {
        let fetchRequest = requestFactory.makeFetchRequest(
            for: modelType,
            sortDescriptors: sortDescriptors
        )

        var result: [Model] = []
        backgroundContext.performAndWait {
            do {
                let fetched = try backgroundContext.fetch(fetchRequest)
                result = try fetched.map(Model.from)
            } catch {
                print("CoreDataStorage fetch error:", error)
            }
        }
        return result
    }

    func replaceAll<Model: Persistable>(_ objects: [Model]) {
        let fetchRequest = requestFactory.makeFetchRequest(for: Model.self)

        backgroundContext.performAndWait {
            do {
                let objects = try backgroundContext.fetch(fetchRequest)
                objects.forEach { backgroundContext.delete($0) }
            } catch {
                print("CoreDataStorage remove error:", error)
            }

            objects.forEach { $0.createDB(in: backgroundContext) }

            do {
                try backgroundContext.save()
            } catch {
                print("CoreDataStorage save error:", error)
            }
        }
    }
}
