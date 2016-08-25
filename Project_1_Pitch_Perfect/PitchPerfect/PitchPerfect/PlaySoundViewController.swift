//
//  PlaySoundViewController2.swift
//  PitchPerfect
//
//  Created by Hasic Dalmir on 25/08/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    var recordedAudioURL: NSURL!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var stopTimer: NSTimer!
    var audioPlayerNode: AVAudioPlayerNode!
    
    enum ButtonType: Int { case Slow = 0, Fast, Chipmunk, Vader, Echo, Reverb} 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        configureUI(.NotPlaying)
    }
    

    @IBAction func playSoundForButton(sender: UIButton) {
         print("Play Sound Button Pressed")
        switch(ButtonType(rawValue: sender.tag)!) {
        case .Slow:
            playSound(rate: 0.5)
        
        case .Fast:
            playSound(rate: 1.5)
        
        case .Chipmunk:
            playSound(pitch: 1000)
        
        case .Vader:
            playSound(pitch: -1000)
        
        case .Echo:
            playSound(echo: true)
            
        case .Reverb:
            playSound(reverb: true)
        }
        
        configureUI(.Playing)
        
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        print("Stop Audio Button Pressed")
        stopAudio()
    }
}
