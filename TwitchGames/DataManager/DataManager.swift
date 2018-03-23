//
//  DataManager.swift
//  TwitchGames
//
//  Created by Piera Marchesini on 22/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

final class DataManager {
    static let sharedInstance = DataManager()
    private let apiKey = "client_id=nw8ybs53s85wa1in5qu55fnjkphv2y"
    var games = [Games.Game]()
    var nextJSON = ""
    
    fileprivate init() { }
    
    func getPopularGames(completed: @escaping () -> ()) {
        let jsonUrlString = "https://api.twitch.tv/kraken/games/top?"+self.apiKey+"&limit=100"
        
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let results = try JSONDecoder().decode(Games.self, from: data)
                DispatchQueue.main.sync {
                    self.games = results.top
                    self.nextJSON = results._links.next
                    completed()
                }
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
    }
    
    func loadMoreGames(offset: Int, completed: @escaping () -> ()) {
        let jsonUrlString = "https://api.twitch.tv/kraken/games/top?"+self.apiKey+"&limit=100&offset=\(offset)"
        
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let results = try JSONDecoder().decode(Games.self, from: data)
                DispatchQueue.main.sync {
                    print(self.games.count)
                    self.games += results.top
                    print(self.games.count)
                    self.nextJSON = results._links.next
                    completed()
                }
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
    }
}
