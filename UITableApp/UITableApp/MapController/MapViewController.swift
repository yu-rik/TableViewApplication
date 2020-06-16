//
//  MapViewController.swift
//  UITableApp
//
//  Created by yurik on 6/16/20.
//  Copyright © 2020 yurik. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var place: Place!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func Close() {
        dismiss(animated: true) // метод закрывает ViewController  и выгружает его из памяти
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMark() //вызов метода при переходе на viewController

        
    }
    
    //метод который указывает положение на карте
    private func setUpMark() {
        //извлечение адреса заведения
        guard let location = place.location else {return}
        
        //создаем экземпляр класса CLGeocoder() - преобразование географических координат(долготы и широты) и географических названий
        let geocoder = CLGeocoder()
        
        //метод позволяет определить положение на карте по адресу переданному в параметры
        geocoder.geocodeAddressString(location) { (placemarks, error) in
           // проверка на содержание объекта error каких = либо данных
            if let error = error {
                print(error) //если error не содержит  nil - выводим ошибку на консоль и выходим из метода
                return
            } else {
                //если ошибки нет - извлекаем опционал из объекта placemarks
                guard let placemarks = placemarks else {return}
                
                let placemark = placemarks.first //первый индекс массива placemarks - метка на карте
                
                //присваиваем метке название и другие параметры
                let annotation = MKPointAnnotation() // для описания точки на карте
                annotation.title = self.place.name // название места
                annotation.subtitle = self.place.type // тип заведения
                
                //привязываем созданную анотацию к конкретной точки на карте в соотвествии с местоположением маркера
               //определяем положение маркера
                guard let placemarkLocation = placemark?.location else {return}
                
                //привязка анотации к точке на карте
                annotation.coordinate = placemarkLocation.coordinate
                
                //задаем видимую область карты - чтоб были видны все созданные аннотации
                self.mapView.showAnnotations([annotation], animated: true)
                
                //выделяем созданную аннотацию на карте
                self.mapView.selectAnnotation(annotation, animated: true)
            }
        }
        
        
        
    }


}
