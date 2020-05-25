//
//  ViewController.swift
//  course2
//
//  Created by Cesar Nascimento on 24/05/20.
//  Copyright © 2020 Cesar Nascimento. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var isAndroidImage = true
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonOtherImage: UIButton!
    
    @IBAction func onButtonOtherImagePressed(_ sender: UIButton) {
        if (isAndroidImage) {
            imageView.image = UIImage(named: "ios")
            isAndroidImage = false
        } else {
            imageView.image = UIImage(named: "android")
            isAndroidImage = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageView.image = UIImage(named: "android")
    }


}

