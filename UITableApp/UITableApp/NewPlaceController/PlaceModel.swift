//
//  PlaceModel.swift
//  UITableApp
//
//  Created by yurik on 6/6/20.
//  Copyright © 2020 yurik. All rights reserved.
//

import RealmSwift

class Place : Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var date = Date()
    @objc dynamic var raitinG = 0.0
    
    
    convenience init(name: String, location: String?, type: String?, imageData: Data?, raiting : Double){
        //инициализатор(convenience initv) должен вызывать инициализатор самого класса с пустыми параметрами
        self.init() //для того чтобы можно инициализировать все свойства значениями по умолчанию
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
        self.raitinG = raiting
    }
}

