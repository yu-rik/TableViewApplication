//
//  MapViewController.swift
//  UITableApp
//
//  Created by yurik on 6/16/20.
//  Copyright © 2020 yurik. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation //для определения местоположения пользователя

protocol MapViewControllerDelegate {
    func getAddress(_ address: String?)
}

class MapViewController: UIViewController {
   
    let mapManager = MapManager() //вызов всех необходимых методов для работы с картами
    
    
    //свойсттво типа протокола MapViewControllerDelegate
    var mapViewControllerDelegate: MapViewControllerDelegate?
    
    var place = Place()
    
    //уникальный идентификатор
    let annotationIdentifier = "annotationIdentifier"
    
    var incomeSegueIdentifier = "" //идентификатор segue - для вызова того или другого segue
    

    
    //свойство для хранения предыдущего местороложения пользователя
    var previousLocation: CLLocation?
        
    
    
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var adrressLabel: UILabel!
    @IBOutlet weak var mapPinImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adrressLabel.text = ""
        //подписываем делегата ответственного за выполнения методов протокола MKMapViewDelegate
        //или в storyboard перетянуть лучиком от mapView к mapViewController  и выбрать delegate
        mapView.delegate = self
        setupMapView()
    }
    
    @IBAction func centerVviewInUserLocation() {
        mapManager.showUserLocation(mapView: mapView) // позиционирование карты по местоположению пользователя
    }
    
    @IBAction func doneButtonPresed() {
        mapViewControllerDelegate?.getAddress(adrressLabel.text) //передача в getAddress-протокола текущее значение адреса
        dismiss(animated: true) //после передачи данных закрытие viewController
    }
   
    @IBAction func goButtonPressed() {
        mapManager.getDirection(for: mapView) { (location) in
            self.previousLocation = location
        }
        
    }
    
    
    @IBAction func Close() {
        dismiss(animated: true) // метод закрывает ViewController  и выгружает его из памяти
    }
    
    
    
    
    
    
    private func setupMapView() {
       goButton.isHidden = true
        mapManager.checkLocationServices(mapView: mapView, segueIdentifier: incomeSegueIdentifier) {
            mapManager.locationManager.delegate = self
        }

        if incomeSegueIdentifier == "showMap" {

            mapManager.setUpMark(place: place, mapView: mapView) //вызов метода при переходе на viewController и позиционирование карты по местоположению заведения
            mapPinImage.isHidden = true //скрываем маркер с карты расположения заведения
            adrressLabel.isHidden = true
            doneButton.isHidden = true
            goButton.isHidden = false
        }
    }
    
    
    
   
   
    
    private func setUpLocationManager(){
        //чтоб отрабатывался метод протокола CLLocationManagerDelegate назначаем делегат
        mapManager.locationManager.delegate = self
        
        //точность определения местоположения пользователя
        mapManager.locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
    
    //метод для отображения адресса находящиегося в центре карты
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //определяем координаты центра
        let center = mapManager.getCenterLocation(for: mapView)
        let geocoder = CLGeocoder() // преобразование географических координат и названий
        // преобразование координат в адресс
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            //проверка на наличие ошибок
            if let error = error{
                print(error)
                return
            }
            
            //если ошибок нету присваиваем константе placemarks массив координат
            guard let placemarks = placemarks else { return }
            
            //вытаскиваем из нового массива первый элемент
            let placemark = placemarks.first
            
            //извлекаем улицу и номер дома
            let streetName = placemark?.thoroughfare //улица
            let buildNumber = placemark?.subThoroughfare //дом
        
            
            
            //передаем значения в Label
            
            //для обновления данных в основном потоке асинхронно
            DispatchQueue.main.async {
                //проверка на nil
                if streetName != nil && buildNumber != nil {
                    self.adrressLabel.text = "\(streetName!), \(buildNumber!)"
                } else if streetName != nil {
                     self.adrressLabel.text = "\(streetName!)"
                } else {
                    self.adrressLabel.text = ""
                }
                 
            }
           
        }
    }
    
    //наложение цветной линии на карту
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        
        //красим в цвет
        renderer.strokeColor = .green
        return renderer
    }
}

extension MapViewController : CLLocationManagerDelegate {
    //метод вызывается при каждом изменении статуса авторизации приложения для использования служб геолокации
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // в случае любого изменения статуса вызывается метод
        mapManager.checkLocationAutorization(mapView: mapView, segueIdentifier: incomeSegueIdentifier)
    }
}
