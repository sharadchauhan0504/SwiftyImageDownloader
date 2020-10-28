//
//  SwiftyImageDownloader.swift
//  SwiftyImage
//
//  Created by Sharad on 23/10/20.
//

import UIKit

class SwiftyImageDownloader: UIImageView {
 
    let imageFolderName = "SwiftyImage"
    
    func downloadImageFrom(url: URL) {
        let queue = DispatchQueue(label: "ImageDownloader", qos: .background, attributes: .concurrent, autoreleaseFrequency: .workItem, target: .none)
        queue.async { [weak self] in
            guard let strongSelf = self else {return}
            let fileName = url.absoluteString.fileName()
            if strongSelf.checkIfFileExist(fileName), let imageData = strongSelf.getSavedImageData(fileName) {
                DispatchQueue.main.async {
                    strongSelf.image = UIImage(data: imageData)
                }
            } else {
                URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    guard let strongSelf = self, let imageData = data, error == nil, let downloadedImage = UIImage(data: imageData) else { return }
                    strongSelf.saveImage(fileName, imageData)
                    DispatchQueue.main.async {
                        strongSelf.image = downloadedImage
                    }
                }.resume()
            }
        }
    }
    
    private func getSavedImageData(_ fileName: String) -> Data? {
        do {
            let documentsURL = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
            let savedURL = documentsURL.appendingPathComponent("\(fileName)")
            return try Data(contentsOf: savedURL)
        } catch {
            print ("file error: \(error)")
            return nil
        }
    }
    
    private func saveImage(_ fileName: String, _ imageData: Data) {
        do {
            let documentsURL = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
            let savedURL = documentsURL.appendingPathComponent("\(fileName)")
            try imageData.write(to: savedURL)
        } catch {
            print ("file error: \(error)")
        }
    }
    
    private func checkIfFileExist(_ fileName: String) -> Bool {
        do {
            let documentsURL = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
            let savedURL = documentsURL.appendingPathComponent("\(fileName)")
            return FileManager.default.fileExists(atPath: savedURL.path)
        } catch {
            print ("file error: \(error)")
            return false
        }
    }
}
