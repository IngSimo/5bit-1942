//
//  GameKitController.swift
//  Doctor Home
//
//  Created by Mirko Pennone on 09/02/18.
//  Copyright © 2018 5-bit. All rights reserved.
//

import Foundation
import GameKit

protocol GameKitDelegate {
    func modelUpdated(update: String)
    func errorUpdating()
}

class GameKitController {

    var delegates: [GameKitDelegate] = []

    let localPlayer=GKLocalPlayer.localPlayer()
    var leaderboard = GKLeaderboard()
    let leaderboardId = "grp.gamehighscores"
    var scores: [GKScore] = []

    var didLoadScores = false

    var canUseGameCenter: Bool = false {
        didSet {if canUseGameCenter == true {

            // load leaderboard

//                reportScore(newScore: 352)
//            loadScores()

            }
        }}

    private static var controller: GameKitController = {

        var controller = GameKitController()

        return controller

    }()

    class func shared() -> GameKitController {
        return controller
    }

    func autenthicatePlayer(viewController: UIViewController) {

        print("Authenticating...")
        localPlayer.authenticateHandler = {(ViewController, error) -> Void      in

            if((ViewController) != nil) {
                print("Presenting the login view...")
                viewController.present(ViewController!, animated: true, completion: nil)

            } else if (self.localPlayer.isAuthenticated) {

                print("Local player already authenticated")
                self.canUseGameCenter = true

            } else {

                print("Local player could not be authenticated.")
                self.canUseGameCenter = false

                if((ViewController) != nil) {
                    viewController.present(ViewController!, animated: true, completion: nil)
                }

            }

        }

    }

    func loadScores() {

        leaderboard.identifier = leaderboardId
        leaderboard.playerScope = GKLeaderboardPlayerScope.global
        leaderboard.range = NSRange(location: 1, length: 3)
        leaderboard.loadScores { (scores, error) in

            if (error == nil) {

                if (scores != nil) {
                    self.scores = scores!
                    print("Loaded scores:")
                    print(scores!)
                } else {
                    print("No scores found while loading!")
                }

                self.loadUserScore()

                DispatchQueue.main.async() {
                    if error == nil {
                        for delegate in self.delegates {
                            delegate.modelUpdated(update: "loadScores")
                        }
                    }
                }

            } else {

                print("Error loading scores: \(error!)")
                DispatchQueue.main.async() {
                    for delegate in self.delegates {
                        delegate.errorUpdating()
                    }
                }

            }

        }

    }

    func loadUserScore() {

        // get the user score from the leaderboard
        if let gameCenterScore = (leaderboard.localPlayerScore?.value) {

            // if the local highscore in the user defaults is less than the gameCenterScore, update it
            print("gameCenterScore: \(gameCenterScore)")
            if(UserDefaults.standard.integer(forKey: "highscore") < gameCenterScore) {

                UserDefaults.standard.set(gameCenterScore, forKey: "highscore")

            }

            UserDefaults.standard.set(leaderboard.localPlayerScore?.rank, forKey: "rank")

        }
    }

    func saveScore(newScore: Int) {

        if (UserDefaults.standard.integer(forKey: "highscore")<newScore) {

            // save the local score
            UserDefaults.standard.set(newScore, forKey: "highscore")
            print("hey")
            let score = GKScore.init(leaderboardIdentifier: leaderboardId, player: localPlayer)
            score.value = Int64(newScore)
            GKScore.report([score], withCompletionHandler: { (error) in

                if (error == nil) {

                    print("Reported new score (\(newScore)).")

                    DispatchQueue.main.async() {
                        if error == nil {
                            for delegate in self.delegates {
                                delegate.modelUpdated(update: "saveScore")
                            }
                        }
                    }

                } else {
                    print("Error reporting score: \(error!)")
                    DispatchQueue.main.async() {
                        for delegate in self.delegates {
                            delegate.errorUpdating()
                        }
                    }
                }

            })

        } else {

            DispatchQueue.main.async() {
                for delegate in self.delegates {
                    delegate.modelUpdated(update: "saveScore")
                }
            }

        }

    }

}
