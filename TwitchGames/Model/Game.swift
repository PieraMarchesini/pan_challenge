//
//  Game.swift
//  TwitchGames
//
//  Created by Piera Marchesini on 22/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import Foundation

struct Games: Decodable {
    let top: [Game]

    struct Game: Decodable {
        let game: GameDetail
        let viewers: Int
        let channels: Int
    }
    struct GameDetail: Decodable {
        let _id: Int
        let name: String
        let box: Image
    }
    struct Image: Decodable {
        let large: String
    }
}
