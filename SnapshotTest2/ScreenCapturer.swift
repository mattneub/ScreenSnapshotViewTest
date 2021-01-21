

import UIKit

struct ScreenCapturer {
    static var capturesFolderName = "captures"
    static var captureFilePrefix = "capture"
    static func getCaptureFolderURL() throws -> URL {
        let fm = FileManager.default
        let docsUrl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let ourFolderUrl = docsUrl.appendingPathComponent(capturesFolderName)
        return ourFolderUrl
    }
    static func ensureCaptureFolder() throws {
        let url = try getCaptureFolderURL()
        let fm = FileManager.default
        try fm.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }
    static func captureFileUrlNow() throws -> URL {
        try ensureCaptureFolder()
        let formatter = ISO8601DateFormatter()
        let nowString = formatter.string(from: Date())
        let filename = captureFilePrefix + nowString
        let url = try getCaptureFolderURL()
            .appendingPathComponent(filename)
            .appendingPathExtension("jpg")
        return url
    }
    static func capture() {
        let snapview = UIScreen.main.snapshotView(afterScreenUpdates: true)
        let renderer = UIGraphicsImageRenderer(size: snapview.bounds.size)
        let image = renderer.image { _ in
            snapview.drawHierarchy(in: snapview.bounds, afterScreenUpdates: true)
        }
        if let data = image.jpegData(compressionQuality: 0.8) {
            do {
                let url = try captureFileUrlNow()
                try data.write(to: url)
                print(url) // so we can check manually what got written in simulator
            } catch {
                print("ERROR:", error)
            }
        }
    }
}
