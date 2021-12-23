//
//  ImageManager.swift
//  FoodTracker
//
//  Created by Gael G. on 12/22/21.
//

import Foundation
import SwiftUI

/// Manages thumbnail images from Coins to prevent re-downloading
class ImageManager {
    
    static let instance = ImageManager()
    private init() {}
    
    /// Saves an image to cachesDirectory
    /// - Parameters:
    ///   - image: Image to save
    ///   - imageName: Name of image to save
    ///   - folderName: Name of folder to save image inside
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        
        guard
            let data = image.jpegData(compressionQuality: 1),
            let url = getURLFromImage(imageName: imageName, folderName: folderName)
        else { return }
        
        do {
            try data.write(to: url)
        } catch {
            print("Error saving image [\(imageName)]: \(error)")
        }
    }
    
    /// Loads an image from a folder
    /// - Parameters:
    ///   - imageName: Name of image to load
    ///   - folderName: Name of folder image is inside
    /// - Returns: Image
    func loadImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getURLFromImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    /// Creates a folder if it does not exist
    /// - Parameter folderName: Name of folder to look for, or create
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating directory [\(folderName)]: \(error)")
            }
        }
    }
    
    /// Gets the path for a folder name if it exists in cachesDirectory
    /// - Parameter folderName: Name of folder to look for
    /// - Returns: Path of folder or Nil if folder does not exist
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return url.appendingPathComponent(folderName)
    }
    
    /// Creates the path for a specific image in a folder
    /// - Parameters:
    ///   - imageName: Name of image to look for
    ///   - folderName: Name of folder to look inside of
    /// - Returns: Path for image
    private func getURLFromImage(imageName: String, folderName: String) -> URL? {
        guard let folder = getURLForFolder(folderName: folderName) else { return nil }
        return folder.appendingPathComponent(imageName + ".jpeg")
    }
}

