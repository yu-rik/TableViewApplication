//
//  NewPlaceViewController.swift
//  UITableApp
//
//  Created by yurik on 6/8/20.
//  Copyright © 2020 yurik. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {

    @IBOutlet weak var imageOfPlace: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let cameraIicon = #imageLiteral(resourceName: "camera") //иконка алерта для меню пункта камера
            let photoIcon = #imageLiteral(resourceName: "photo")  //иконка алерта для меню пункта фото
            
            
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            camera.setValue(cameraIicon, forKey: "image") //добавление иконки
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true)
            
        }else{
            view.endEditing(true)
        }
    }
  
}
//MARK: TextFieldDelegate
extension NewPlaceViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
  
//MARK: Work with Image
extension NewPlaceViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{

       func chooseImagePicker(source: UIImagePickerController.SourceType){
           if UIImagePickerController.isSourceTypeAvailable(source){
               let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
               imagePicker.allowsEditing = true //позволяет редактировать фото пользователю
               imagePicker.sourceType = source
               present(imagePicker, animated: true)
        }
       }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageOfPlace.image = info[.editedImage] as? UIImage
        imageOfPlace.contentMode = .scaleAspectFit
        imageOfPlace.clipsToBounds = true
        dismiss(animated: true)
    }
}
