//
//  CustomTableViewCell.swift
//  UITableApp
//
//  Created by yurik on 6/5/20.
//  Copyright © 2020 yurik. All rights reserved.
//

import UIKit
import Cosmos

class CustomTableViewCell: UITableViewCell {

    //добавляем observer didSet для изменения свойств отображения картинки в ячейке
    @IBOutlet weak var imageOfPlace: UIImageView! {
        didSet {
           imageOfPlace.layer.cornerRadius = (imageOfPlace.frame.size.height)/2 //cell.frame.size.height -значение высоты ячейки родительского класса UITableViewCell
                imageOfPlace.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    //аутлету cosmosView добавляем observer didSet для того чтоб убрать случайное нажатие на рэйтинг-звезд и менять их количество
    @IBOutlet weak var cosmosView: CosmosView! {
        didSet {
            cosmosView.settings.updateOnTouch = false // в storyboard  это можно убрать attributes inspector  в UpdateOnTouch
        }
    }
    
}
