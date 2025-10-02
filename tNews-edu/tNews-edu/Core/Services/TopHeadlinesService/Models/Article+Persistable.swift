//
//  Article+Persistable.swift
//  tNews-edu
//
//  Created by Nikita Terin on 24.09.2025.
//

import CoreData

final class DBArticle: NSManagedObject {
    @NSManaged var source: DBSource?
    @NSManaged var author: String?
    @NSManaged var title: String?
    @NSManaged var descriptionString: String?
    @NSManaged var url: String?
    @NSManaged var urlToImage: String?
    @NSManaged var publishedAt: Date?
    @NSManaged var content: String?
}

extension Article: Persistable {
    typealias DBType = DBArticle

    static func from(_ dbModel: DBArticle) throws -> Article {
        var source: Source?
        if let dbSource = dbModel.source {
            source = try? Source.from(dbSource)
        }

        return Article(
            source: source,
            author: dbModel.author,
            title: dbModel.title,
            description: dbModel.descriptionString,
            url: dbModel.url,
            urlToImage: dbModel.urlToImage,
            publishedAt: dbModel.publishedAt,
            content: dbModel.content
        )
    }

    func createDB(in context: NSManagedObjectContext) -> DBArticle {
        let dbModel = DBArticle(context: context)
        dbModel.source = source?.createDB(in: context)
        dbModel.author = author
        dbModel.title = title
        dbModel.descriptionString = description
        dbModel.url = url
        dbModel.urlToImage = urlToImage
        dbModel.publishedAt = publishedAt
        dbModel.content = content
        return dbModel
    }
}
