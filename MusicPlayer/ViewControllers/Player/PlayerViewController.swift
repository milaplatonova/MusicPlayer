//
//  PlayerViewController.swift
//  MusicPlayer
//
//  Created by Lyudmila Platonova on 8/17/19.
//  Copyright © 2019 Lyudmila Platonova. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var trackDurationLabel: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var trackDurationSlider: UISlider!
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet var buttons: [UIButton]!
    
    var currentIndex: Int = 0
    var allSongsURLs: [URL] = []
    var player: AVPlayer?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.configureGradientBackground(#colorLiteral(red: 0.432338, green: 0.91194, blue: 0.742786, alpha: 1), #colorLiteral(red: 0.0512438, green: 0.50995, blue: 0.477114, alpha: 1), #colorLiteral(red: 0.68408, green: 0.245274, blue: 0.704975, alpha: 1))
        
        for button in buttons {
            button.backgroundColor = UIColor.clear
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 3
            button.layer.borderColor = #colorLiteral(red: 0.3642524701, green: 0.2781471972, blue: 0.5461955293, alpha: 1)
        }
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_:)))
        swipeRecognizer.direction = .down
        trackImage.addGestureRecognizer(swipeRecognizer)
        
        let currentSong = self.allSongsURLs[currentIndex]
        playSong(with: currentSong)
        
        trackDurationSlider.addTarget(self, action: #selector(durationSliderValueChanged(sender:event:)), for: UIControl.Event.allTouchEvents)
        
    }
    
    @objc
    func swipe(_ sender: UISwipeGestureRecognizer) {
        timer?.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func durationSliderValueChanged(sender: UISlider, event: UIEvent) {
        guard let touchEvent = event.allTouches?.first else { return }
        switch touchEvent.phase {
        case .began:
            player?.pause()
            timer?.invalidate()
            break
        case .moved:
            break
        case .ended:
            player?.seek(to: CMTime(seconds: Double(sender.value),preferredTimescale: 1))
            player?.play()
            self.startTimer()
            break
        default:
            break
        }
    }
    
    func playSong(with url: URL) {
        player?.pause()
        let item = AVPlayerItem(url: url)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
        if player == nil {
            player = AVPlayer(playerItem: item)
            player?.volume = 0.1
        } else {
            player?.replaceCurrentItem(with: item)
        }
        player?.play()
        currentTimeLabel.text = getAllTime(with: 0.0)
        setDuration()
    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        currentIndex += 1
        if currentIndex >= allSongsURLs.count {
            currentIndex = 0
        }
        let currentSong = allSongsURLs[currentIndex]
        playSong(with: currentSong)
    }
    
    func getAllTime(with duration: Double) -> String {
        let minutes = Int(duration / 60.0)
        let second = duration - (Double(minutes) * 60.0)
        return "\(minutes):" + String(format: "%02d", Int(second))
    }
    
    func setDuration() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let playerItem = self.player?.currentItem, playerItem.status == AVPlayerItem.Status.readyToPlay {
                let durationTime = playerItem.duration.seconds
                let metadataList = playerItem.asset.commonMetadata
                var title: String = ""
                var artist: String = ""
                for item in metadataList {
                    guard let key = item.commonKey else {
                        return
                    }
                    if key.rawValue == "title" {
                        title = item.stringValue ?? ""
                    }
                    if key.rawValue == "artist" {
                        artist = item.stringValue ?? ""
                        artist = artist.replacingOccurrences(of: " [drivemusic.me]", with: "")
                    }
                    self.trackTitleLabel.text = ("\(artist) - \(title)")
                }
                self.timer?.invalidate()
                self.startTimer()
                self.trackDurationSlider.value = 0.0
                self.trackDurationSlider.maximumValue = Float(durationTime)
                self.trackDurationSlider.minimumValue = 0.0
                self.trackDurationLabel.text = self.getAllTime(with: durationTime)
            } else {
                self.setDuration()
            }
        }
    }
    
    func startTimer() {
        timer = Timer(timeInterval: 0.1, repeats: true, block: { _ in
            guard let currentTime = self.player?.currentTime().seconds else { return }
            self.currentTimeLabel.text = self.getAllTime(with: currentTime)
            self.trackDurationSlider.setValue(Float(currentTime), animated: true)
        })
        RunLoop.main.add(self.timer!, forMode: .common)
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        if sender.isSelected {
            player?.play()
            startTimer()
        } else {
            player?.pause()
            timer?.invalidate()
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func changeTrackAction(_ sender: UIButton) {
        var currentValue = 0
        if sender.tag == 1 {
            currentValue = currentIndex + 1
            if currentValue >= allSongsURLs.count {
                currentValue = 0
            }
        } else {
            currentValue = currentIndex - 1
            if currentValue < 0 {
                currentValue = allSongsURLs.count - 1
            }
        }
        currentIndex = currentValue
        let nextTrack = allSongsURLs[currentValue]
        playSong(with: nextTrack)
    }
    
    @IBAction func volumeAction(_ sender: UIButton) {
        if sender.isSelected {
            player?.volume = volumeSlider.value
        } else {
            player?.volume = 0.0
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func volumeSliderValueChanged(_ sender: UISlider) {
        player?.volume = sender.value
    }
    
}
