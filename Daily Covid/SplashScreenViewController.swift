//
//  SplashScreenViewController.swift
//  Daily Covid
//
//  Created by Basti Belmonte on 4/26/22.
//

import UIKit
import AVFoundation

class SplashScreenViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playSound(name: "cough0")
    }
    
    func playSound(name: String) {
        if let sound = NSDataAsset(name: name) {
            do {
                audioPlayer = try AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch {
                print("Error")
            }
        } else {
            print("Error")
        }
    }
    
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "ShowTableView", sender: sender)
    }
    

}

