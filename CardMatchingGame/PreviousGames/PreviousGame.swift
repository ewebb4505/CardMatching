//
//  PreviousGame.swift
//  CardMatchingGame
//
//  Created by Evan Webb on 6/22/22.
//

import Foundation

struct PreviousGames: Codable {
    
    var previousGames: [PreviousGame]?
    
    struct PreviousGame: Codable {
        var date: Date
        var time: Double
        var numberOfTaps: Int
    }
    
    
    
    public init() {
        guard let data = readLocalFile(forName: "PreviousGames") else {
            fatalError("Getting data from PreviousGames file was nil")
        }
        
        do {
            let jsonDecoder = JSONDecoder()
            var decodedArrOfPreviousGames = try jsonDecoder.decode(PreviousGames.self, from: data)
            self.previousGames = decodedArrOfPreviousGames.previousGames
        } catch {
            fatalError("Tried getting previousGame data. Failed at init")
        }
    }
    
    ///https://programmingwithswift.com/parse-json-from-file-and-url-with-swift/
    ///this method comes from the resource above.
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
}


