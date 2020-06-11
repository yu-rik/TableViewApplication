//
//  MainViewController.swift
//  UITableApp
//
//  Created by yurik on 6/4/20.
//  Copyright © 2020 yurik. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {


    
    //var places = Place.getPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    // MARK: - Table view data source


  /*  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return places.count
    }*/

    
  /*  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Jacheyka", for: indexPath) as! CustomTableViewCell
       //---------------------- заполнение полей ячейки ****** start
        let place = places[indexPath.row]
        
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        
        if place.image == nil{
           cell.imageOfPlace.image = UIImage(named: place.restaurantImage!)
        }else {
            cell.imageOfPlace.image = place.image
        }
        //-------------------- end
 
        
        cell.imageOfPlace.layer.cornerRadius = (cell.imageOfPlace.frame.size.height)/2 //cell.frame.size.height -значение высоты ячейки родительского класса UITableViewCell
        cell.imageOfPlace.clipsToBounds = true
        

        return cell
    }
     */
    
   /* // MARK: - TableViewDelegate
     //метод возвращает высоту строки, если выcоту строки указывать в storyboard, то этот метод не нужен
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    */
    
   /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //связь кнопки Save с unwindSegue
/* @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
    //создаем экземпляр класса NewPlaceViewController с извлечением опционала через guard
    guard let newPlaceVC = segue.source as? NewPlaceViewController else {return} //с помощью .source получаем данные и приводим их к типу NewPlaceViewController
    newPlaceVC.saveNewPlace() //вызов метода-добавления значений в модель из класса NewPlaceViewController
    places.append(newPlaceVC.newPlace!) // добавление в массив новых значений введенных пользователем
    tableView.reloadData() // обновление интерфейса
    
    }*/

}
