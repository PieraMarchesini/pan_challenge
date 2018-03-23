//
//  DataManager.swift
//  TwitchGames
//
//  Created by Piera Marchesini on 22/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit
import CoreData
import Reachability

protocol DataManagerDelegate:class {
    func didFinishLoading()
}

final class DataManager {
    static let sharedInstance = DataManager()
    weak var delegate:DataManagerDelegate?
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let apiKey = "client_id=nw8ybs53s85wa1in5qu55fnjkphv2y"
    var games: [Games.Game] {
        if ReachabilityManager.shared.reachability.connection == .none {
            return self.fetchPersistedGames()
        } else {
            return self.tempGames
        }
    }
    
    private var tempGames = [Games.Game]()
    
    
    fileprivate init() { }
    
    func getPopularGames(completed: @escaping () -> ()) {
        let jsonUrlString = "https://api.twitch.tv/kraken/games/top?"+self.apiKey+"&limit=100"
        
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let results = try JSONDecoder().decode(Games.self, from: data)
                DispatchQueue.main.sync {
                    self.tempGames = results.top
                    completed()
                }
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
        
        self.delegate?.didFinishLoading()
    }
    
    func loadMoreGames(offset: Int, completed: @escaping () -> ()) {
        let jsonUrlString = "https://api.twitch.tv/kraken/games/top?"+self.apiKey+"&limit=100&offset=\(offset)"
        
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let results = try JSONDecoder().decode(Games.self, from: data)
                DispatchQueue.main.sync {
                    self.tempGames += results.top
                    completed()
                }
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
    }
    
    func persistGames() {
        for game in self.tempGames {
            let newGame = PersistentGame(context: self.context)
            newGame.id = Int32(game.game._id)
            newGame.name = game.game.name
            newGame.image = game.game.box.large
            newGame.channels = Int32(game.channels)
            newGame.viewers = Int32(game.viewers)
            
            do {
                try context.save()
            } catch {
                print("Failed saving favorite")
            }
        }
    }
    
    private func fetchPersistedGames() -> [Games.Game]{
        var popGames = [PersistentGame]()
        var persistedGames = [Games.Game]()
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PersistentGame")
            request.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false)]
            popGames = try context.fetch(request) as! [PersistentGame]
            
            
            for pop in popGames {
                let game = Games.Game(game: Games.GameDetail(_id: Int(pop.id), popularity: Int(pop.popularity), name: pop.name ?? "", box: Games.Image(large: pop.image ?? "")), viewers: Int(pop.viewers), channels: Int(pop.channels))
                
                persistedGames.append(game)
            }
        } catch {
            print("Failed to fetch persistent games from CoreData")
        }
        
        self.delegate?.didFinishLoading()
        
        return persistedGames
    }
    
    func deletePersistedGames() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PersistentGame")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                context.delete(data)
                try context.save()
            }
        } catch {
            print("Failed deleting games from CoreData")
        }
    }
}
