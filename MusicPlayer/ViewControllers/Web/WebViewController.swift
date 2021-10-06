//
//  WebViewController.swift
//  MusicPlayer
//
//  Created by Lyudmila Platonova on 8/11/19.
//  Copyright © 2019 Lyudmila Platonova. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.configureGradientBackground(#colorLiteral(red: 0.432338, green: 0.91194, blue: 0.742786, alpha: 1), #colorLiteral(red: 0.0512438, green: 0.50995, blue: 0.477114, alpha: 1), #colorLiteral(red: 0.68408, green: 0.245274, blue: 0.704975, alpha: 1))
        
        webView.navigationDelegate = self
        
        if let url = URL(string: "https://drivemusic.me") {
            webView.load(URLRequest(url: url))
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let url = navigationResponse.response.url {
            let stringURL = url.absoluteString
            print(stringURL)
            if stringURL.contains("https://drivemusic.me/") {
                decisionHandler(.allow)
            } else {
                if stringURL.contains("https://dnl12.drivemusic.me/") {
                    NetworkingManager.shared.download(with: stringURL)
                }
                decisionHandler(.cancel)
            }
        } else {
            // .allow to allow the URL or .cancel to deny access navigationResponse.responce.url
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) { }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) { }
    
}
