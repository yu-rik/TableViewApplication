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
    //var restaurantImage: String?
    
      let restaurantsName = ["Puzata hata","Napaleon hill","Big mac","Stolovaya #5","Uzbek","Proreznaya","Ludmila","Oaza","Partenit","Semeiz","Vepr", "Velyka bochka","Praga","London","Toronto"]
    
    func savePlaces() {
        
        for place in restaurantsName {
          let image = UIImage(named: place)
            //перевод изображения UIImage  в тип Data
            guard let imageDat = image?.pngData() else{return}
            
            
            let newPlace = Place() // экземпляр модели
            //присваиваем свойствам экземпляра значения:
            newPlace.name = place
            newPlace.location = "Kyiv"
            newPlace.type = "Restaurant"
            newPlace.imageData = imageDat
            
            StorageManager.saveObject(newPlace) //при каждой итеррации объект будет сохраняться в базу
            
        }
       
    }
}

/*    static func getPlaces() ->[Place]{
    var places = [Place]()
    for place in restaurantsName {
        places.append(Place(name: place, location: "Киев", type: "Ресторан", image: nil, restaurantImage: place))
    }
    return places
}
*/
