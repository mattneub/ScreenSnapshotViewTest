
import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UIViewController {
    @IBOutlet weak var iv: UIImageView!
    
    @IBAction func doButton(_ sender: Any) {
        self.view.backgroundColor = .yellow
        delay(0.1) {
            ScreenCapturer.capture()
            self.view.backgroundColor = .red // to provide contrast
            // ok, let's see what that did
            do {
                let folder = try ScreenCapturer.getCaptureFolderURL()
                let fm = FileManager.default
                let images = try fm.contentsOfDirectory(at: folder, includingPropertiesForKeys: [], options: [])
                if let image = images.sorted(by: {$0.lastPathComponent < $1.lastPathComponent}).last {
                    print(image)
                    let data = try Data(contentsOf: image)
                    let image = UIImage(data: data)
                    self.iv.image = image
                }
            } catch {
                print("error:", error)
            }
        }
    }
    
}

