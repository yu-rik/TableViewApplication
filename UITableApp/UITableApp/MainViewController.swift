//
//  MainViewController.swift
//  UITableApp
//
//  Created by yurik on 6/4/20.
//  Copyright © 2020 yurik. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {


    
    let places = Place.getPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Jacheyka", for: indexPath) as! CustomTableViewCell
        cell.nameLabel.text = places[indexPath.row].name
        cell.locationLabel.text = places[indexPath.row].location
        cell.typeLabel.text = places[indexPath.row].type
        cell.imageOfPlace.image = UIImage(named: places[indexPath.row].image)
        cell.imageOfPlace.layer.cornerRadius = (cell.imageOfPlace.frame.size.height)/2 //cell.frame.size.height -значение высоты ячейки родительского класса UITableViewCell
        cell.imageOfPlace.clipsToBounds = true
        

        return cell
    }
    
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

}
