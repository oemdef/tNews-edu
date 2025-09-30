//
//  PublishedDateTimeFormatter.swift
//  tNews-edu
//
//  Created by Nikita Terin on 19.08.2025.
//

import Foundation

protocol IPublishedDateTimeFormatter: AnyObject {
    func string(from publishedAtDate: Date?, currentDate: Date) -> String?
}

final class PublishedDateTimeFormatter: IPublishedDateTimeFormatter {

    private let relativeDateTimeFormatter: RelativeDateTimeFormatter

    init(relativeDateTimeFormatter: RelativeDateTimeFormatter = RelativeDateTimeFormatter()) {
        relativeDateTimeFormatter.calendar = .autoupdatingCurrent
        relativeDateTimeFormatter.locale = .autoupdatingCurrent
        relativeDateTimeFormatter.dateTimeStyle = .named
        relativeDateTimeFormatter.unitsStyle = .abbreviated
        self.relativeDateTimeFormatter = relativeDateTimeFormatter
    }

    func string(from publishedAtDate: Date?, currentDate: Date) -> String? {
        guard let publishedAtDate else { return nil }

        return relativeDateTimeFormatter.localizedString(for: publishedAtDate, relativeTo: currentDate)
    }
}
