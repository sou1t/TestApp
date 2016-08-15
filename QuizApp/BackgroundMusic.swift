//
//  BackgroundMusic.swift
//  QuizApp
//
//  Created by Виталий Волков on 30.07.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import AVFoundation

var backgroundMusicPlayer = AVAudioPlayer()

func playBackgroundMusic(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(filename, withExtension: "mp3")
    guard let newURL = url else {
        print("Could not find file: \(filename)")
        return
    }
    do {
        backgroundMusicPlayer = try AVAudioPlayer(contentsOfURL: newURL)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.volume = 0.5
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    } catch let error as NSError {
        print(error.description)
    }
}

func stopBGmusic()  {
    backgroundMusicPlayer.stop()
}