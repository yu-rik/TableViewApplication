//
//  StorageManager.swift
//  UITableApp
//
//  Created by yurik on 6/11/20.
//  Copyright © 2020 yurik. All rights reserved.
//

//файл для работы с базой
import RealmSwift

//создаем  объект realm который будет предоставлять доступ к базе
let realm = try! Realm()

class StorageManager {
    //метод для сохранения объектов с типом Place
    static func saveObject(_ place: Place){
        //запись в базу данных
        try! realm.write {
            realm.add(place)
        }
    }
    //метод для удаления объектов с типом Place
    static func deleteObject(_ place: Place){
        try! realm.write {
            realm.delete(place)
        }
    }
}
