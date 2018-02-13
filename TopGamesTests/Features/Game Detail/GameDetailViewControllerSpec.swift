//
//  GameDetailViewControllerSpec.swift
//  TopGamesTests
//
//  Created by Matheus Weber on 13/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit
import Quick
import Nimble
import Nimble_Snapshots

@testable import TopGames

final class GameDetailViewControllerSpec: QuickSpec {
    override func spec() {
        var listGames: [TopModel]!
        
        context("when initializing GameGridDetailViewController with mock controller") {
            var sut: GameDetailViewController!
            
            beforeEach {
                let mockable = Mockable()
                listGames = mockable.mock(jsonFile: "TopsMock")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                sut = storyboard.instantiateViewController(withIdentifier: "gameDetail") as! GameDetailViewController
                sut.loadView()
                sut.topModel = listGames[0]
                
                _ = sut.view
                sut.viewDidLoad()
            }
            
            afterEach {
                sut = nil
            }
            
            it("should not be nil") {
                expect(sut).toNot(beNil())
            }
    
            it("should have the expected layout when screen loads") {
                expect(sut.view).to( haveValidSnapshot(named: "GameDetailViewController") )
            }
        }
        
    }
}
