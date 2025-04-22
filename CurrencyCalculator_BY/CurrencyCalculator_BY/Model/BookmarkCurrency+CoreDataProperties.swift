//
//  BookmarkCurrency+CoreDataProperties.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/22/25.
//
//

import Foundation
import CoreData


extension BookmarkCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkCurrency> {
        return NSFetchRequest<BookmarkCurrency>(entityName: "BookmarkCurrency")
    }

    @NSManaged public var currencyCode: String?

}

extension BookmarkCurrency : Identifiable {

}
