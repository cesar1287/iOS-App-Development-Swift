//
//  ViewController.swift
//  course2
//
//  Created by Cesar Nascimento on 24/05/20.
//  Copyright © 2020 Cesar Nascimento. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var shareMenu: UIView!
    
    @IBOutlet var editMenu: UIView!
    
    @IBOutlet weak var bottomMenu: UIView!
    
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var compareButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!

    @IBOutlet weak var labelOriginal: UILabel!
    
    @IBOutlet weak var sliderFilter: UISlider!
    
    var originalImage: UIImage?
    var modifiedImage: UIImage?
    var usedFilter = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageView.image = UIImage(named: "android")
        
        originalImage = imageView.image
        modifiedImage = imageView.image
        
        shareMenu.translatesAutoresizingMaskIntoConstraints = false
        editMenu.translatesAutoresizingMaskIntoConstraints = false
        
        tapRecognizer.numberOfTapsRequired = 2
    }
    
    func showFilterButton() {
        view.addSubview(shareMenu)
        
        let bottomConstraint = shareMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = shareMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = shareMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        let heightConstraint = shareMenu.heightAnchor.constraint(equalToConstant: 44)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        self.shareMenu.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.shareMenu.alpha = 1
            self.filterButton.isSelected = true
        })
        
        view.layoutIfNeeded()
    }
    
    func hideFilterButton() {
        UIView.animate(withDuration: 0.4, animations: {
            self.shareMenu.alpha = 0
        }, completion: { completed in
            if completed == true {
                self.shareMenu.removeFromSuperview()
                self.filterButton.isSelected = false
            }
        })
    }
    
    func showEditButton() {
        view.addSubview(editMenu)
        
        let bottomConstraint = editMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = editMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = editMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        let heightConstraint = editMenu.heightAnchor.constraint(equalToConstant: 44)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        self.editMenu.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.editMenu.alpha = 1
            self.editButton.isSelected = true
        })
        
        view.layoutIfNeeded()
    }
    
    func hideEditButton() {
        UIView.animate(withDuration: 0.4, animations: {
            self.editMenu.alpha = 0
        }, completion: { completed in
            if completed == true {
                self.editMenu.removeFromSuperview()
                self.editButton.isSelected = false
            }
        })
    }
    
    func processImage(filter: String, _ value: Float) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        print(filter, " - ", value)
        
        usedFilter = filter
        
        // background task
        DispatchQueue.global(qos: .userInitiated).async {

            let myRGBA = RGBAImage(image: self.modifiedImage!)
            var formulas = Formulas(myRGBA: myRGBA!)
            
            switch filter {
                case "brightness":
                    formulas.myRGBA = formulas.applyBrightnessToImage(desiredLevelBrightness: Int(value))
                case "contrast":
                    formulas.myRGBA = formulas.applyContrastToImage(desiredLevelContrast: value)
                case "greyscale":
                    formulas.myRGBA = formulas.applyGreyscaleByWeightToImage()
                case "inversion":
                    formulas.myRGBA = formulas.applyColourInversionToImage()
                case "gamma":
                    formulas.myRGBA = formulas.applyGammaToImage(desiredLevelGamma: 2.0)
                default:
                    formulas.myRGBA = myRGBA!
            }

            // return to the main thread
            DispatchQueue.main.async {
                
                self.imageView.image = formulas.myRGBA.toUIImage()
                
                self.modifiedImage = self.imageView.image
                self.compareButton.isEnabled = true
                self.editButton.isEnabled = true

                // stop animating now that background task is finished
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func onBrightnessFilterPressed(_ sender: UIButton) {
        processImage(filter: "brightness", 128)
        defaultSliderConfig()
    }
    
    @IBAction func onContrastFilterPressed(_ sender: UIButton) {
        processImage(filter: "contrast", 128.0)
        defaultSliderConfig()
    }
    
    @IBAction func onGreyscaleFilterPressed(_ sender: UIButton) {
        processImage(filter: "greyscale", 128)
        defaultSliderConfig()
    }
    
    @IBAction func onInversionFilterPressed(_ sender: UIButton) {
        processImage(filter: "inversion", 128)
        defaultSliderConfig()
    }
    
    @IBAction func onGammaFilterPressed(_ sender: UIButton) {
        processImage(filter: "gamma", 2.0)
    }
    
    func ajustSliderToGamma() {
        sliderFilter.minimumValue = 0.01
        sliderFilter.maximumValue = 7.99
        sliderFilter.value = 2.0
    }
    
    func defaultSliderConfig() {
        sliderFilter.minimumValue = -255.0
        sliderFilter.maximumValue = 255.0
        sliderFilter.value = 128.0
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let albumPicker = UIImagePickerController()
        albumPicker.delegate = self
        albumPicker.sourceType = .photoLibrary
        
        present(albumPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            
            originalImage = imageView.image
            modifiedImage = imageView.image
            compareButton.isEnabled = false
            editButton.isEnabled = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSharePressed(_ sender: UIButton){
        labelOriginal.isHidden = true
        imageView.image = modifiedImage
        
        let activityController = UIActivityViewController(activityItems: ["Checkout our amazing app", imageView.image!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func onNewPhotoPressed(_ sender: UIButton) {
        labelOriginal.isHidden = true
        imageView.image = modifiedImage
        
        let actionSheet = UIAlertController.init(title: "New Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    @IBAction func onEditPressed(_ sender: UIButton) {
        labelOriginal.isHidden = true
        hideFilterButton()
        
        if sender.isSelected {
            hideEditButton()
        } else {
            showEditButton()
            imageView.image = modifiedImage
        }
    }
    
    @IBAction func onFilterPressed(_ sender: UIButton) {
        labelOriginal.isHidden = true
        hideEditButton()
        
        if sender.isSelected {
            hideFilterButton()
        } else {
            showFilterButton()
            imageView.image = modifiedImage
        }
    }
    
    @IBAction func onComparePressed(_ sender: UIButton) {
        labelOriginal.isHidden = false
        imageView.image = originalImage
        hideFilterButton()
        hideEditButton()
    }
    
    @IBAction func onSliderChanged(_ sender: UISlider) {
        processImage(filter: usedFilter, sender.value)
    }
    
    @IBAction func onImagePressed(_ sender: UITapGestureRecognizer) {
        print("image pressed")
        imageView.image = originalImage
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            self.imageView.image = self.modifiedImage
        }
    }
}
