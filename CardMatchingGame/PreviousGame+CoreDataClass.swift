//
//  PreviousGame+CoreDataClass.swift
//  CardMatchingGame
//
//  Created by Evan Webb on 6/26/22.
//
//

import Foundation
import CoreData

@objc(PreviousGame)
public class PreviousGame: NSManagedObject, Comparable {
    
    public static func < (lhs: PreviousGame, rhs: PreviousGame) -> Bool {
        return lhs.time < rhs.time
    }
    
    
}
