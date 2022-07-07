//
//  PreviousGame+CoreDataProperties.swift
//  CardMatchingGame
//
//  Created by Evan Webb on 6/26/22.
//
//

import Foundation
import CoreData


extension PreviousGame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PreviousGame> {
        return NSFetchRequest<PreviousGame>(entityName: "PreviousGame")
    }

    @NSManaged public var date: Date?
    @NSManaged public var numOfTaps: Int16
    @NSManaged public var time: Int32

}

extension PreviousGame : Identifiable {

}
