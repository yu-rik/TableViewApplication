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
    
    //уникальный идентификатор
    let annotationIdentifier = "annotationIdentifier"
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func Close() {
        dismiss(animated: true) // метод закрывает ViewController  и выгружает его из памяти
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //подписываем делегата ответственного за выполнения методов протокола MKMapViewDelegate
        //или в storyboard перетянуть лучиком от mapView к mapViewController  и выбрать delegate
        mapView.delegate = self
        
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
extension MapViewController : MKMapViewDelegate{
    //
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {return nil} //если положением на карте является текущее положение то выходим из метода вернув nil
        
        // представляет View c аннотацией на карте
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView // приводим к MKPinAnnotationView чтоб отобразился маркер в виде булавки
         
        // если на карте нету ниодного представления с аннотацией которое можно переиспользовать, то присваиваем annotationView новый объект
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
             //отображение аннотации в виде баннера
            annotationView?.canShowCallout = true
        }
        
        
        //размещаем изображение на баннере
        
        if let imageData = place.imageData { //проверка на опционал
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) //инициализируем изображение - задаем координаты и размеры картинки
            imageView.layer.cornerRadius = 10 //скругляем радиусы
            imageView.clipsToBounds = true // обрезаем изображение по границам imageView
            imageView.image = UIImage(data: imageData) // помещаем само изображение в imageView
            
            //размещение imageView на баннере с правой стороны
            annotationView?.rightCalloutAccessoryView = imageView
        }
        
        
        
        
        
        return annotationView
    }
}
