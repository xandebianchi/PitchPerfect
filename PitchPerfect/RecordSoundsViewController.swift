//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Alexandre Bianchi on 15/10/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    struct Constants {
        static let TapToRecord = "Tap to Record"
        static let RecordingInProgress = "Recording in Progress"
        static let RecordingNotSuccessFull = "Recording was not successful"
        static let StopRecordingSegueId = "stopRecording"
        static let LocalFileName = "recordedVoice.wav"
    }
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // MARK: Default functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeComponentsStatus(isRecording: false)
    }
    
    // MARK: Record actions

    @IBAction func recordAudio(_ sender: Any) {
        changeComponentsStatus(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = Constants.LocalFileName
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
 
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        changeComponentsStatus(isRecording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: Change button and label status
    
    func changeComponentsStatus(isRecording: Bool) {
        if (isRecording == true) {
            setRecordButtonsEnabled(false)
            recordingLabel.text = Constants.RecordingInProgress
        } else {
            setRecordButtonsEnabled(true)
            recordingLabel.text = Constants.TapToRecord
        }
    }
    
    func setRecordButtonsEnabled(_ recordButtonStatus: Bool) {
        recordButton.isEnabled = recordButtonStatus
        stopRecordingButton.isEnabled = !recordButtonStatus
    }

    // MARK: Audio Recorder Delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: Constants.StopRecordingSegueId, sender: audioRecorder.url)
        } else {
            print(Constants.RecordingNotSuccessFull)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.StopRecordingSegueId {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}
