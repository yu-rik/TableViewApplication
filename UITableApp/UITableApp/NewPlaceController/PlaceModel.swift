//
//  PlaceModel.swift
//  UITableApp
//
//  Created by yurik on 6/6/20.
//  Copyright © 2020 yurik. All rights reserved.
//

import UIKit

struct Place {
    var name: String
    var location: String?
    var type: String?
    var image: UIImage?
    var restaurantImage: String?
    
     static let restaurantsName = ["Puzata hata","Napaleon hill","Big mac","Stolovaya #5","Uzbek","Proreznaya","Ludmila","Oaza","Partenit","Semeiz","Vepr", "Velyka bochka","Praga","London","Toronto"]
    
    static func getPlaces() ->[Place]{
        var places = [Place]()
        for place in restaurantsName {
            places.append(Place(name: place, location: "Киев", type: "Ресторан", image: nil, restaurantImage: place))
        }
        return places
    }
}
