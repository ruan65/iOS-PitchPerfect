//
//  ViewControllerRecordSounds.swift
//  PitchPerfect
//
//  Created by Andrey Rudenko on 03/01/2017.
//  Copyright © 2017 premiumapp. All rights reserved.
//

import UIKit
import AVFoundation

class ViewControllerRecordSounds: UIViewController, AVAudioRecorderDelegate {
    
    let playSoundsVcIdentifier = "stopRecording"
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }

    @IBAction func recordAudio(_ sender: Any) {
        
        recordingLabel.text = "Recording..."
        recordButton.isEnabled = false
        stopRecordingButton.isEnabled = true
        
        recordAudio()
    }
    
    func recordAudio() {
        
        let dirPath = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: Any) {
        
        recordingLabel.text = "Tap to Record"
        stopRecordingButton.isEnabled = false
        recordButton.isEnabled = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: playSoundsVcIdentifier, sender: audioRecorder.url)
        } else {
            print("recording was not successful...")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == playSoundsVcIdentifier {
            
            let playSoundsVC = segue.destination as! ViewControllerPlaySounds
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

