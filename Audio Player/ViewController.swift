//
//  ViewController.swift
//  Audio Player
//
//  Created by MAC006 on 13/02/20.
//  Copyright © 2020 MAC006. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var mainView                 : UIView!
    @IBOutlet var tableView                     : UITableView!
    @IBOutlet weak var audioView                : UIView!
    @IBOutlet weak var playerPopupView          : UIView!
    @IBOutlet weak var playerPopupDismissBtn    : UIButton!
    @IBOutlet weak var confNameLabel            : UILabel!
    @IBOutlet weak var confDateTimeLabel        : UILabel!
    @IBOutlet weak var shareRecBtn              : UIButton!
    @IBOutlet weak var pauseRecBtn              : UIButton!
    @IBOutlet weak var volumeRecBtn             : UIButton!
    @IBOutlet weak var deleteRecBtn             : UIButton!
    
    var recArr = ["Conference 1","Conference 2","Conference 3","Conference 4","Conference 5","Conference 6","Conference 7","Conference 8","Conference 9","Conference 10"]
    
    let audioArr = ["ncs0","ncs1","ncs2","ncs3","hello"]
    
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioView.isHidden = true
        playerPopupView.isHidden = true
        playerPopupView.layer.cornerRadius = 14
        
        // Setting action button default images
        pauseRecBtn.setImage(UIImage.init(named: "play"), for: UIControl.State.normal)
        volumeRecBtn.setImage(UIImage.init(named: "volume"), for: UIControl.State.normal)
        
    }
    
    
    @IBAction func playerPopupDismissAction(_ sender: UIButton) {
        audioView.isHidden = true
        playerPopupView.isHidden = true
        pauseRecBtn.setImage(UIImage.init(named: "play"), for: UIControl.State.normal)
        volumeRecBtn.setImage(UIImage.init(named: "volume"), for: UIControl.State.normal)
        audioPlayer.pause()
    }
    
    @IBAction func shareRecAction(_ sender: UIButton) {
        let activityController = UIActivityViewController(activityItems: [confNameLabel.text!, audioArr[sender.tag]], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func pauseRecAction(_ sender: UIButton) {
        if pauseRecBtn.imageView?.image == UIImage.init(named: "play") {
            pauseRecBtn.setImage(UIImage.init(named: "pause"), for: UIControl.State.normal)
            audioPlayer.play()
        }
        else {
            pauseRecBtn.setImage(UIImage.init(named: "play"), for: UIControl.State.normal)
            audioPlayer.pause()
        }
    }
    
    @IBAction func recVolumeAction(_ sender: UIButton) {
        if volumeRecBtn.imageView?.image == UIImage.init(named: "mute") {
            volumeRecBtn.setImage(UIImage.init(named: "volume"), for: UIControl.State.normal)
            audioPlayer.setVolume(1.0, fadeDuration: 0.0)
        }
        else {
            volumeRecBtn.setImage(UIImage.init(named: "mute"), for: UIControl.State.normal)
            audioPlayer.setVolume(0.0, fadeDuration: 0.0)
        }
    }
    
    @IBAction func deleteRecAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Recording", message: "Are you sure you want to delete this recording?", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (action) in
            self.recArr.remove(at: sender.tag)
            self.audioView.isHidden = true
            self.playerPopupView.isHidden = true
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
            // Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func playAudio(filename: String, fileExtension: String) {
      let audio = Bundle.main.path(forResource: filename, ofType: fileExtension)
      
      do {
          audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audio!))
          audioPlayer.prepareToPlay()
          
          let audioSession = AVAudioSession.sharedInstance()
          try audioSession.setCategory(
              AVAudioSession.Category.playback,
              mode: AVAudioSession.Mode.default,
              options: [AVAudioSession.CategoryOptions.duckOthers]
          )
      } catch {
          print("error")
      }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecordingsTableViewCell
        cell.selectionStyle = .none
        cell.recNameLbl.text? = recArr[indexPath.row]
        cell.playRecBtn.tag = indexPath.row
        cell.playRecBtn.addTarget(self, action: #selector(playBtnAction(_:)), for: UIControl.Event.touchUpInside)
        return cell
    }
    
    @objc func playBtnAction(_ sender: UIButton) {
        audioView.isHidden = false
        playerPopupView.isHidden = false
        
        let rowIndex:Int = sender.tag

        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        let dateTimeString = formatter.string(from: currentDateTime)
        
        confNameLabel.text = recArr[rowIndex]
        confDateTimeLabel.text = dateTimeString
        print("Tag : \(rowIndex + 1)")
        
        playAudio(filename: audioArr[sender.tag], fileExtension: "mp3")
        
    }
    
}
