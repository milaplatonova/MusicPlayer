//
//  MainViewController.swift
//  MusicPlayer
//
//  Created by Lyudmila Platonova on 8/11/19.
//  Copyright © 2019 Lyudmila Platonova. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.configureGradientBackground(#colorLiteral(red: 0.432338, green: 0.91194, blue: 0.742786, alpha: 1), #colorLiteral(red: 0.0512438, green: 0.50995, blue: 0.477114, alpha: 1), #colorLiteral(red: 0.68408, green: 0.245274, blue: 0.704975, alpha: 1))
        
        musicButton.layer.cornerRadius = 8
        searchButton.layer.cornerRadius = 8
        
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if sender.tag == 0 {
            let storyboard = UIStoryboard(name: "FilesViewController", bundle: nil)
            if let vc = storyboard.instantiateInitialViewController() {
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let storyboard = UIStoryboard(name: "WebViewController", bundle: nil)
            if let vc = storyboard.instantiateInitialViewController() {
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
