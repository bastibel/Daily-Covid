//
//  MenuViewController.swift
//  Daily Covid
//
//  Created by Basti Belmonte on 4/27/22.
//

import UIKit
import AVFoundation

class MenuViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dataButton: UIButton!
    @IBOutlet weak var variantsButton: UIButton!
    @IBOutlet weak var safetyButton: UIButton!
    
    
    var currentCoughSound = 0
    let maxCoughSound = 5
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    func playSound(soundName: String) {
        if let sound = NSDataAsset(name: soundName) {
            do {
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch {
                print("Error 1")
            }
        } else {
            print("Error 2")
        }
    }
    
    @IBAction func dataButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ShowData", sender: self)
    }
    @IBAction func variantsButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ShowVariants", sender: self)
    }
    @IBAction func safetyButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ShowSafety", sender: self)
    }
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        playSound(soundName: "cough\(currentCoughSound)")
        currentCoughSound += 1
        if currentCoughSound >= maxCoughSound {
            currentCoughSound = 0
    }
}
}
