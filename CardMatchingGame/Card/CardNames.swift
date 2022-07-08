//
//  CardNames.swift
//  CardMatchingGame
//
//  Created by Webb, Terry on 6/7/22.
//

import Foundation

public enum CardFace: CaseIterable {
    case Bucket,
         ThumbsUp,
         Bike,
         Skateboard,
         Sun
//         EightBall,
//         RedCard,
//         Diamond,
//         GreenHeart,
//         Football,
//         Martini,
//         CandyBar,
//         Corn,
//         Lights,
//         Phone
    
    
    public func getImageNameFromCardName() -> String {
        switch self {
            case .Bucket: return "🪣"
            case .ThumbsUp: return "👍"
            case .Bike: return "🚲"
            case .Skateboard: return "🛹"
            case .Sun: return "☀️"
//            case .EightBall: return "🎱"
//            case .RedCard: return "🚗"
//            case .Diamond: return "💎"
//            case .GreenHeart: return "💚"
//            case .Football: return "🏈"
//            case .Martini: return "🍸"
//            case .CandyBar: return "🍫"
//            case .Corn: return "🌽"
//            case .Lights: return "🚦"
//            case .Phone: return "☎️"
            
       
        }
    }
}
