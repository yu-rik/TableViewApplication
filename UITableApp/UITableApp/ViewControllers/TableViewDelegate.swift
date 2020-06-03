//
//  TableViewDelegate.swift
//  UITableApp
//
//  Created by yurik on 6/3/20.
//  Copyright © 2020 yurik. All rights reserved.
//

import Foundation
import UIKit

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //отображает количество строк для работы с таблицей
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // работает с самой ячейкой, контент отображаемый в ячейке
        let cell = tableView.dequeueReusableCell(withIdentifier: "Jacheyka")
        cell?.textLabel?.text = "Jacheyka"
        return cell!
    }
    
    
}
