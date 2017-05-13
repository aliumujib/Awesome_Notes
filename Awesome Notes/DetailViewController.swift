//
//  DetailViewController.swift
//  Awesome Notes
//
//  Created by Abdul-Mujib Aliu on 5/8/17.
//  Copyright © 2017 Abdul-Mujib Aliu. All rights reserved.
//

import UIKit
import CoreData


class DetailViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var locationPhoto: UIImageView!
    @IBOutlet weak var locationName: UITextView!
    @IBOutlet weak var locationDescription: UITextView!
    
    @IBOutlet weak var placeImage: UIImageView!
    
    var imagePicker : UIImagePickerController!
    
    var imagePicked: Bool!
    var isZoomed: Bool!
    
    var initialImageHeight: CGFloat!
    var initialImageWidth: CGFloat!
    var initialImagePosY: CGFloat!
    var initialImagePosX: CGFloat!
    
    var noteToEdit:  Note!
    
    var editMode: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let barBtnItem = self.navigationController?.navigationBar.topItem{
            barBtnItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        locationDescription.layer.borderWidth = 1
        locationDescription.layer.borderColor = TEXTFIELD_BORDER_COLOR.cgColor
        locationDescription.layer.cornerRadius = 3
        
        locationName.layer.borderWidth = 1
        locationName.layer.borderColor = TEXTFIELD_BORDER_COLOR.cgColor
        locationName.layer.cornerRadius = 3
        
        
        imagePicker  = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        imagePicked = false
        isZoomed = false
        
        initialImageHeight = self.placeImage.frame.size.height
        initialImageWidth = self.placeImage.frame.size.width

        initialImagePosX = self.placeImage.frame.origin.x
        initialImagePosY = self.placeImage.frame.origin.y
        
        let dismissKeyBoardTap:   UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.dissmissKeyBoard))
        dismissKeyBoardTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        
        self.view.addGestureRecognizer(dismissKeyBoardTap)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.pickImage))
        placeImage.isUserInteractionEnabled = true
        placeImage.addGestureRecognizer(gestureRecognizer)
        
        locationPhoto.layer.cornerRadius = 3
        
        // Do any additional setup after loading the view.
    }
    
    func dissmissKeyBoard() {
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        if(noteToEdit != nil){
            loadEditingData(note: noteToEdit)
        }else{
            print("NULL NOTE TO EDIT")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        
        if(!isEditing){
        let local : Note = Note(context : context)
        local.relToLocation = LocationLocal.sharedLocationInstance
        var textString: String = locationName.text
        local.title = textString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        local.content = locationDescription.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let image : Images = Images(context: context)
        image.image = placeImage.image
        local.relToImage = image
        }else{
            let local : Note = noteToEdit
            local.relToLocation = LocationLocal.sharedLocationInstance
            var textString: String = locationName.text
            local.title = textString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            local.content = locationDescription.text.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let image : Images = Images(context: context)
            image.image = placeImage.image
            local.relToImage = image
        }
        
        
        appDel.saveContext()
        
       _ =  self.navigationController?.popViewController(animated: true)
    }
    
    func pickImage() {
        
       

        
        if(!imagePicked){
            self.navigationController?.present(imagePicker, animated: true, completion: nil)}
        else{
            if(!isZoomed){
                self.view.backgroundColor = UIColor.black
                toggleViewStates(hidden: true)
                let initialScreenHeight = self.view.frame.size.height
                let initialScreenWidth = self.view.frame.size.width
                self.placeImage.frame  = CGRect(x: 0, y: initialScreenHeight/5, width: initialScreenWidth, height: initialScreenHeight/2)
                isZoomed = true
            }else{
                self.view.backgroundColor = UIColor.white
                toggleViewStates(hidden: false)
                self.placeImage.frame  = CGRect(x: 8, y: 8, width: initialImageWidth, height: initialImageHeight)
                isZoomed = false
            }
        }
    }
    
    func toggleViewStates(hidden: Bool) {
        locationName.isHidden = hidden
        locationDescription.isHidden = hidden
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let selectedImage =  info[UIImagePickerControllerOriginalImage] {
            placeImage.image = selectedImage as! UIImage
            imagePicked  = true
        }
        
         self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    func loadEditingData(note: Note) {
        isEditing = true
        
        self.locationName.text = note.title
        self.locationDescription.text = note.content
        
        if let image = note.relToImage?.image as? UIImage{
            self.locationPhoto.image = image
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
