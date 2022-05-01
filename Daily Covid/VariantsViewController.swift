//
//  VariantsViewController.swift
//  Daily Covid
//
//  Created by Basti Belmonte on 4/29/22.
//

import UIKit

class VariantsViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Covid Variants"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "house"), style: .done, target: self, action: #selector(homeTapped))
        

    }
    
    @objc func homeTapped() {
        dismiss(animated: true, completion: nil)


}
}
