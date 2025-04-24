//
//  LastViewedScreen+CoreDataProperties.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/23/25.
//
//

import Foundation
import CoreData


extension LastViewedScreen {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastViewedScreen> {
        return NSFetchRequest<LastViewedScreen>(entityName: "LastViewedScreen")
    }

    @NSManaged public var screenName: String?
    @NSManaged public var currencyCode: String?

}

extension LastViewedScreen : Identifiable {

}
