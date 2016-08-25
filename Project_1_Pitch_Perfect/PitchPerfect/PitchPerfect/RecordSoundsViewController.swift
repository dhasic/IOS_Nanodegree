//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Hasic Dalmir on 28/05/16.
//  Copyright (c) 2016 abc. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()       
        stopRecordingButton.enabled = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func recordAudio(sender: AnyObject) {
        print("Record button pressed")
        recordingLabel.text = "Recording in progress"
        recordButton.enabled = false
        stopRecordingButton.enabled = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] 
        
        let recordingName = "my_audio.waw"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    
    @IBAction func stopRecording(sender: AnyObject) {
        print("Stop record button pressed")
        recordingLabel.text = "Tap to Record"
        recordButton.enabled = true
        stopRecordingButton.enabled  = false
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        

    }
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear called", terminator: "")
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if(flag){
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        }
        else{
            print("Recording was not successful")
            recordButton.enabled = true
            stopRecordingButton.enabled = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    
}

