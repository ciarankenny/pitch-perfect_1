//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kenny, Ciaran on 4/3/15.
//  Copyright (c) 2015 Kenny, Ciaran. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        //hide the stop button and set the label on the play button
        stopButton.hidden = true;
        recordButton.enabled = true;
        recordingLabel.text = "Tap to Record";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        //set the button displays for recording
        recordingLabel.text = "Recording in Progress";
        stopButton.hidden = false;
        recordButton.enabled = false;
        
        //get the documents directory path and format the filename with the timestamp
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        //set the audioSession category for PlayAndRecord
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate=self;
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
            //If the recording finshed correctly, segue to Play screen
            if (flag) {
                recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
                self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            }else{
                println("Recording was not successful")
                recordButton.enabled = true
                stopButton.hidden = true
            }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController;
            let data = sender as! RecordedAudio;
            playSoundsVC.receivedAudio = data;
        }
    }


    @IBAction func stopRecordAudio(sender: UIButton) {
        audioRecorder.stop();
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil);
    }

}

