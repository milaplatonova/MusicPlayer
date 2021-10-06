//
//  FilesViewController.swift
//  MusicPlayer
//
//  Created by Lyudmila Platonova on 8/11/19.
//  Copyright © 2019 Lyudmila Platonova. All rights reserved.
//

import UIKit
import AVFoundation

class FilesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var player: AVPlayer?
    var startURL: URL?
    var contents: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.layer.configureGradientBackground(#colorLiteral(red: 0.432338, green: 0.91194, blue: 0.742786, alpha: 1), #colorLiteral(red: 0.0512438, green: 0.50995, blue: 0.477114, alpha: 1), #colorLiteral(red: 0.68408, green: 0.245274, blue: 0.704975, alpha: 1))

        if startURL == nil {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            startURL = documentsURL
        }
        
        contents = (try? FileManager.default.contentsOfDirectory(at: startURL!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)) ?? []
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension FilesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contents.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textColor = UIColor.black
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.textLabel?.text = contents[indexPath.row].lastPathComponent
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            let title = contents[indexPath.row].lastPathComponent.capitalized.replacingOccurrences(of: ".Mp3.Mp3", with: ".mp3")
            cell.textLabel?.text = title
            return cell
        }
    }
}

extension FilesViewController: UITableViewDelegate {
    
    func showPlayer(with currentIndex: Int) {
        let storyboard = UIStoryboard(name: "PlayerViewController", bundle: nil)
        if let playerViewController = storyboard.instantiateInitialViewController() as? PlayerViewController {
            playerViewController.modalPresentationStyle = .overFullScreen
            playerViewController.allSongsURLs = contents
            playerViewController.currentIndex = currentIndex
            present(playerViewController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            try? FileManager.default.removeItem(at: self.contents[indexPath.row])
            self.contents.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .right)
            tableView.endUpdates()
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        let path = contents[indexPath.row]
        if fileManager.fileExists(atPath: path.absoluteString.replacingOccurrences(of: "file://", with: ""), isDirectory:&isDir) {
            guard isDir.boolValue else {
                showPlayer(with: indexPath.row)
                return
            }
            if isDir.boolValue {
                let storyboard = UIStoryboard(name: "FilesViewController", bundle: nil)
                if let vc = storyboard.instantiateInitialViewController() as? FilesViewController {
                    vc.startURL = path
                    navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                showPlayer(with: indexPath.row)
            }
        }
    }
    
}


