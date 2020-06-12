//
//  MainViewController.swift
//  UITableApp
//
//  Created by yurik on 6/4/20.
//  Copyright © 2020 yurik. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {
//создаем объект класса Results(тип библиотеки Realm, аналог массива) для запроса к базе и отображения ее данных в интерфейсе
 var places : Results<Place>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // отображение данных на экране при запуске приложения
        //делаем запрос объектов из realm инициализируя свойства places
        places = realm.objects(Place.self) // под Place имеется ввиду тип данных
        
      
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count //если база пуста - возвращаем ноль
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Jacheyka", for: indexPath) as! CustomTableViewCell
       //---------------------- заполнение полей ячейки ----------------start
        let place = places[indexPath.row]
                
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        //----------------------------------- end
         
        cell.imageOfPlace.layer.cornerRadius = (cell.imageOfPlace.frame.size.height)/2 //cell.frame.size.height -значение высоты ячейки родительского класса UITableViewCell
        cell.imageOfPlace.clipsToBounds = true

        return cell
    }
     
    
    // MARK: - TableViewDelegate
     //метод возвращает высоту строки, если выcоту строки указывать в storyboard, то этот метод не нужен
    //override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     //   return 85
   // }
    
    //метод протокола TableViewDelegate, который позволяет вызывать свайпом справа -налево другие методы
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StorageManager.deleteObject(places[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade )
        }
    }
    

    
    
    
    
   
    // MARK: - Navigation

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            //определяем индекс выбранной ячейки
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            //извлекаем объект из массива places по полученному индексу ячейки
            let place = places[indexPath.row]
            //экземпляр NewPlaceViewControllera с помощью которого будем передавать данные на NewPlaceViewController
            let newPlaceVC = segue.destination as! NewPlaceViewController
            // передаем place на newPlaceVC
            newPlaceVC.currentPlace = place
        }
    }
    
    
    //связь кнопки Save с unwindSegue
 @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
    //создаем экземпляр класса NewPlaceViewController с извлечением опционала через guard
    guard let newPlaceVC = segue.source as? NewPlaceViewController else {return} //с помощью .source получаем данные и приводим их к типу NewPlaceViewController
    newPlaceVC.savePlace() //вызов метода-добавления значений в модель из класса NewPlaceViewController
    tableView.reloadData() // обновление интерфейса
    
    }

}
