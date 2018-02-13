//
//  CoreDataManagerSpec.swift
//  TopGamesTests
//
//  Created by Matheus Weber on 13/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit
import Quick
import Nimble

@testable import TopGames

class CoreDataManagerSpec: QuickSpec {
    override func spec() {
        var listGames: [TopModel]!
        
        context("when initializing CoreDataManager") {
            var sut: CoreDataManager!
            
            beforeEach {
                let mockable = Mockable()
                listGames = mockable.mock(jsonFile: "TopsMock")
                
                sut = CoreDataManager.shared
            }
            
            afterEach {
                sut = nil
            }
            
            it("should not be nil") {
                expect(sut).toNot(beNil())
            }
            
            it("should add models to core data") {
                sut.deleteAllData(entity: "Top")
                sut.deleteAllData(entity: "Game")
                sut.deleteAllData(entity: "Image")

                for top in listGames {
                    expect(sut.addGame(topModel: top)).to(beVoid())
                }
            }
            
            it("should retrieve models to core data") {
                listGames = listGames.sorted { $0.viewers > $1.viewers }
                var coreGames = sut.retrieveGames(limit: listGames.count, offset: 0)
                coreGames = coreGames.sorted { $0.viewers > $1.viewers }
                
                for (top, top1) in zip(coreGames, listGames) {
                    expect(top.game.id).to(equal(top1.game.id))
                }
            }
        }
        
    }
}
