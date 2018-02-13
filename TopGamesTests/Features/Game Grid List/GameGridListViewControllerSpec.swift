//
//  GameGridListViewControllerSpec.swift
//  TopGamesTests
//
//  Created by Matheus Weber on 10/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit
import Quick
import Nimble
import Nimble_Snapshots

@testable import TopGames

final class GameGridListViewControllerSpec: QuickSpec {
    override func spec() {
        var listGames: [TopModel]!

        context("when initializing GameGridListViewController with mock controller") {
            var sut: GameGridListViewController!
            
            beforeEach {
                let mockable = Mockable()
                listGames = mockable.mock(jsonFile: "TopsMock")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                sut = storyboard.instantiateViewController(withIdentifier: "gameGridList") as! GameGridListViewController
                sut.loadView()
                sut.topList = listGames
                
                _ = sut.view
                sut.viewDidLoad()
            }
            
            afterEach {
                sut = nil
            }
            
            it("should not be nil") {
                expect(sut).toNot(beNil())
            }
            
            it("should call callMessageView with all types of message") {
                expect(sut.callMessageView(text: "Test", type: RequestType.onlineAgain)).to(beVoid())
                expect(sut.callMessageView(text: "Test", type: RequestType.offlineWithoutData)).to(beVoid())
                expect(sut.callMessageView(text: "Test", type: RequestType.offlineWithData)).to(beVoid())
            }
            
            it("should call get games when online and offline") {
                expect(sut.getGamesWhenOffline()).to(beVoid())
                expect(sut.getGamesWhenOnline()).to(beVoid())
            }
            
            it("should call refresh") {
                expect(sut.refresh(UIButton())).to(beVoid())
            }
            
            it("should call willDisplay") {
                expect(sut.willDisplay()).to(beVoid())
            }
            
            it("should call handleNetworkChange") {
                expect(sut.handleNetworkChange(Notification(name: Notification.Name("Test")))).to(beVoid())
            }
            
            it("should have the expected layout when screen loads") {
                expect(sut.view).to( haveValidSnapshot(named: "GameGridListViewController") )
            }
            
            it("should close and re-open message view") {
                let frame = CGRect(x: 0, y: 60, width: 200, height: 0)
                let nib = UINib(nibName: "MessageView", bundle: nil)
                MessageView.activeMessageView = nib.instantiate(withOwner: self, options: nil)[0] as? MessageView
                MessageView.activeMessageView?.setup(frame: frame, text: "Test", type: RequestType.offlineWithoutData)
                expect(MessageView.callMessageView(in: sut, text: "Test", type: RequestType.offlineWithoutData)).to(beVoid())
            }
        }
        
    }
}
