//
//  PublishedDateTimeFormatter.swift
//  tNews-edu
//
//  Created by Nikita Terin on 19.08.2025.
//

import Foundation

protocol IPublishedDateTimeFormatter: AnyObject {
    func string(from publishedAtDateString: String?, currentDate: Date) -> String?
}

final class PublishedDateTimeFormatter: IPublishedDateTimeFormatter {

    private let iSO8601DateFormatter: ISO8601DateFormatter
    private let relativeDateTimeFormatter: RelativeDateTimeFormatter

    init(
        iSO8601DateFormatter: ISO8601DateFormatter = ISO8601DateFormatter(),
        relativeDateTimeFormatter: RelativeDateTimeFormatter = RelativeDateTimeFormatter()
    ) {
        relativeDateTimeFormatter.calendar = .autoupdatingCurrent
        relativeDateTimeFormatter.locale = .autoupdatingCurrent
        relativeDateTimeFormatter.dateTimeStyle = .named
        relativeDateTimeFormatter.unitsStyle = .abbreviated

        self.iSO8601DateFormatter = iSO8601DateFormatter
        self.relativeDateTimeFormatter = relativeDateTimeFormatter
    }

    func string(from publishedAtDateString: String?, currentDate: Date) -> String? {
        guard let publishedAtDateString,
              let publishedAtDate = iSO8601DateFormatter.date(from: publishedAtDateString) else { return nil }

        return relativeDateTimeFormatter.localizedString(for: publishedAtDate, relativeTo: currentDate)
    }
}
