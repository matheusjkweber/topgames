//
//  CoreDataManager.swift
//  TopGames
//
//  Created by Matheus Weber on 11/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    static var appDelegate = AppDelegate()
    static var shared = CoreDataManager()
    
    var managedContext: NSManagedObjectContext
    
    init() {
        managedContext = CoreDataManager.appDelegate.persistentContainer.viewContext
    }
    
    func alreadyAdded(with id: Int) -> Bool {
        let gameFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
        gameFetch.predicate = NSPredicate(format: "id = %@", "\(id)")

        do {
            let games = try managedContext.fetch(gameFetch)
            return !games.isEmpty
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return false
    }
    
    func addGame(topModel: TopModel) {
        if !alreadyAdded(with: topModel.game.id) {
            let topEntity = NSEntityDescription.entity(forEntityName: "Top", in: managedContext)!
            
            let top = NSManagedObject(entity: topEntity, insertInto: managedContext)
            top.setValue(topModel.channels, forKey: "channels")
            top.setValue(topModel.viewers, forKey: "viewers")
            
            let gameEntity = NSEntityDescription.entity(forEntityName: "Game", in: managedContext)!
            let game = NSManagedObject(entity: gameEntity, insertInto: managedContext)
            game.setValue(topModel.game.localizedName, forKey: "localizedName")
            game.setValue(topModel.game.id, forKey: "id")
            game.setValue(topModel.game.name, forKey: "name")
            game.setValue(topModel.game.popularity, forKey: "popularity")
            game.setValue(topModel.game.giantbombId, forKey: "giantbombId")
            game.setValue(topModel.game.locale, forKey: "locale")
            
            let imageEntity = NSEntityDescription.entity(forEntityName: "Image", in: managedContext)!
            let box = NSManagedObject(entity: imageEntity, insertInto: managedContext)
            box.setValue(topModel.game.box.large, forKey: "large")
            box.setValue(topModel.game.box.medium, forKey: "medium")
            box.setValue(topModel.game.box.small, forKey: "small")
            box.setValue(topModel.game.box.template, forKey: "template")
            
            let logo = NSManagedObject(entity: imageEntity, insertInto: managedContext)
            logo.setValue(topModel.game.logo.large, forKey: "large")
            logo.setValue(topModel.game.logo.medium, forKey: "medium")
            logo.setValue(topModel.game.logo.small, forKey: "small")
            logo.setValue(topModel.game.logo.template, forKey: "template")
            
            game.setValue(box, forKey: "box")
            game.setValue(logo, forKey: "logo")
            
            top.setValue(game, forKey: "game")
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func retrieveGames() -> [TopModel] {
        let topFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Top")
        var topList = [TopModel]()
        do {
            if let tops = try managedContext.fetch(topFetch) as? [Top] {
                for top in tops {
                    let topModel = TopModel(top: top)
                    topList.append(topModel)
                }
            }
        } catch let error as NSError {
            print("Could not load. \(error), \(error.userInfo)")
        }
        
        return topList
    }
}
