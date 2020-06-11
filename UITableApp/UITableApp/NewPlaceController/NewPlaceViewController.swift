//
//  NewPlaceViewController.swift
//  UITableApp
//
//  Created by yurik on 6/8/20.
//  Copyright © 2020 yurik. All rights reserved.
//

import UIKit


class NewPlaceViewController: UITableViewController {
   
    var imageIsChanged = false // дополнительное свойство на случай если пользователь не добавит свое изображение

   
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
             
        tableView.tableFooterView = UIView() //скрытие лишних разлинеек отображаемых на виде
        saveButton.isEnabled = false
        
        //отслеживвание внесения данных в поле textFieldName и включение/выключение кнопки Save
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged) // при редактировании поля textFieldName вызывается метод textFieldChanged
        
    }
    
//MARK: Table ViewDelegate
    // при выборе окна-изображения вызывается Alert с пунктами Camera, Photo, Cancel
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
            view.endEditing(true) //скрытие клавиатуры
        }
    }
  
    //метод сохранения введеных данныхиз полей в модель PlaceModel
    func saveNewPlace(){
      //создаем экземпляр модели для присваивания значений свойствам модели Place 
      //  let newPlace = Place()
        
        var image: UIImage?
        if imageIsChanged{
           image = placeImage.image
        }else{
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        //присваиваем значения свойствам модели Place
        let imageConvert = image?.pngData() //конвертируем изображение из UIImage в тип DATA
//        newPlace.name = placeName.text!
//        newPlace.location = placeLocation.text
//        newPlace.type = placeType.text
//        newPlace.imageData = imageConvert
        //инициализация с помощью init() класса
        let newPlace = Place(name: placeName.text!, location: placeLocation.text, type: placeType.text, imageData: imageConvert)
        
        //сохранение объекта в базе данных
        StorageManager.saveObject(newPlace)
      
    }
    @IBAction func actionCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true) //метод который закрывает NewPlaceViewController  и выгружает его из памяти
    }
    
}

//MARK: TextFieldDelegate
extension NewPlaceViewController : UITextFieldDelegate {
    // скрытие клавиатуры по нажатию на кнопку Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //ьетод включает кнопку SAVE если поле textFieldName заполненно
    @objc private func textFieldChanged(){
        if placeName.text?.isEmpty == false{
            saveButton.isEnabled = true
        }else{
            saveButton.isEnabled = false
        }
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
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFit
        placeImage.clipsToBounds = true
        
        imageIsChanged = true //картинка не меняется
        dismiss(animated: true)
    }
}
