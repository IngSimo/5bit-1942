//
//  GameViewController.swift
//  1942-Remake
//
//  Created by Walter Purcaro on 07/03/2018.
//  Copyright © 2018 5-bit. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation //add this

class GameViewController: UIViewController {

    var bgSoundPlayer: AVAudioPlayer? //add this

    func loadTextures() {
        // Load TextureAtlas
        let playerAtlas = SKTextureAtlas(named: "Sprites")

        // Get the list of texture names, and sort them
        let textureNames = playerAtlas.textureNames.sorted {
            (first, second) -> Bool in
            return first < second
        }

        // Load all textures
        GameManager.shared.allTextures = textureNames.map {
            return playerAtlas.textureNamed($0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.integer(forKey: "highscore") == nil {

            UserDefaults.standard.set(0, forKey: "highscore")

        }

        if UserDefaults.standard.integer(forKey: "rank") == nil {

            UserDefaults.standard.set(0, forKey: "rank")

        }

        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.playBackgroundSound(_:)), name: NSNotification.Name(rawValue: "PlayBackgroundSound"), object: nil) //add this to play audio

        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.stopBackgroundSound), name: NSNotification.Name(rawValue: "StopBackgroundSound"), object: nil) //add this to stop the audio

        // Create view
        guard let view = self.view as! SKView? else {
            return
        }

        loadTextures()

//        let scene = GameScene(size: view.frame.size)
        let scene = MenuScene(size: view.frame.size)

        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill

        // Debug
        //maybe true
        view.ignoresSiblingOrder = false
        view.showsFPS = false
        view.showsNodeCount = false
        view.showsPhysics = false

        // Present the scene
        view.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return [.portrait, .portraitUpsideDown]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @objc func playBackgroundSound(_ notification: Notification) {

        print("Play song!")

        //get the name of the file to play from the data passed in with the notification
        let name = (notification as NSNotification).userInfo!["fileToPlay"] as! String

        print("Name of the song: \(name)")

        //if the bgSoundPlayer already exists, stop it and make it nil again
        if (bgSoundPlayer != nil) {

//            bgSoundPlayer!.stop()
//            bgSoundPlayer = nil

            print("There is already a song playing, don't do anything...")

            return

        }

        //as long as name has at least some value, proceed...
        if (name != "") {

            //create a URL variable using the name variable and tacking on the "mp3" extension
            let fileURL: URL = Bundle.main.url(forResource: name, withExtension: "wav")!

            //basically, try to initialize the bgSoundPlayer with the contents of the URL
            do {
                bgSoundPlayer = try AVAudioPlayer(contentsOf: fileURL)
                print("Song is at URL: \(fileURL)")
            } catch _ {
                bgSoundPlayer = nil
                print("bgSoundPlayer is nil!")

            }

            bgSoundPlayer!.volume = 0.75 //set the volume anywhere from 0 to 1
            bgSoundPlayer!.numberOfLoops = -1 // -1 makes the player loop forever
            bgSoundPlayer!.prepareToPlay() //prepare for playback by preloading its buffers.
            bgSoundPlayer!.play() //actually play

        }

    }

    @objc func stopBackgroundSound() {

        print("Stop song!")
        //if the bgSoundPlayer isn't nil, then stop it
        if (bgSoundPlayer != nil) {

            bgSoundPlayer!.stop()
            bgSoundPlayer = nil

        }

    }

}
