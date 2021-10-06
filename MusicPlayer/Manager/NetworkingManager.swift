//
//  NetworkingManager.swift
//  MusicPlayer
//
//  Created by Lyudmila Platonova on 8/11/19.
//  Copyright © 2019 Lyudmila Platonova. All rights reserved.
//

import Alamofire

class NetworkingManager {
    static let shared = NetworkingManager()
    
    func download(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("music/\(urlString.components(separatedBy: "/").last ?? "file").mp3")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(url, to: destination).downloadProgress { (progress) in
            print("\((progress.completedUnitCount * 100) / progress.totalUnitCount )%")
        }.response { (response) in
            print()
        }
    }
    
}
