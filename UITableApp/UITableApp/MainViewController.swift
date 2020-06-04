//
//  MainViewController.swift
//  UITableApp
//
//  Created by yurik on 6/4/20.
//  Copyright © 2020 yurik. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    let restaurantsName = ["Puzata hata","Napaleon hill","Big mac","Stolovaya #5","Uzbek","Proreznaya","Ludmila","Oaza","Partenit","Semeiz","Vepr",
                           "Velyka bochka","Praga","London","Toronto"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return restaurantsName.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Jacheyka", for: indexPath)
        cell.textLabel?.text = restaurantsName[indexPath.row]
        cell.imageView?.image = UIImage(named: restaurantsName[indexPath.row])
        cell.imageView?.layer.cornerRadius = (cell.frame.size.height)/2
        cell.imageView?.clipsToBounds = true
        

        return cell
    }
    
    // MARK: - TableViewDelegate
     //метод возвращает высоту строки
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
   /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
