//
//  SafetyViewController.swift
//  Daily Covid
//
//  Created by Basti Belmonte on 4/29/22.
//

import UIKit

class SafetyViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "house"), style: .done, target: self, action: #selector(homeTapped))
      //  navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Blue Covid-2"), style: .done, target: self, action: #selector(homeTapped))
        title = "Safety Measures"

        
    }
    
    @objc func homeTapped() {
        dismiss(animated: true, completion: nil)


}
}
