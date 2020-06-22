//
//  MapManager.swift
//  UITableApp
//
//  Created by yurik on 6/21/20.
//  Copyright © 2020 yurik. All rights reserved.
//

import UIKit
import MapKit

// перенести в этот класс все свойства и методы которые не влияют на работу MapViewController
class MapManager {
    
    //для управления действиями с местоположением пользователя создаем экземпляр класса CLLocationManager()
    let locationManager = CLLocationManager()
    
    //свойство принимающее координаты заведения
   private var placeCoordinate: CLLocationCoordinate2D?
   private let regionInMeters = 5_000.00
    

    //МАРКЕР ЗАВЕДЕНИЯ метод который указывает положение маркера на карте(добавляем два параметра в метод)
    func setUpMark(place: Place, mapView: MKMapView) {
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
                   annotation.title = place.name // название места
                   annotation.subtitle = place.type // тип заведения
                   
                   //привязываем созданную анотацию к конкретной точки на карте в соотвествии с местоположением маркера
                  //определяем положение маркера
                   guard let placemarkLocation = placemark?.location else {return}
                   
                   //привязка анотации к точке на карте
                   annotation.coordinate = placemarkLocation.coordinate
                   //передача координат placemarkLocation свойству placeCoordinate
                   self.placeCoordinate = placemarkLocation.coordinate
                   
                   
                   //задаем видимую область карты - чтоб были видны все созданные аннотации
                   mapView.showAnnotations([annotation], animated: true)
                   
                   //выделяем созданную аннотацию на карте
                   mapView.selectAnnotation(annotation, animated: true)
               }
           }
       }
    
    // проверка включены ли службы геолокации(вызвать из метода SetUpMapView класса MapViewController, чтоб назначить этот класс делегатом протокола CoreLocationManagerDelegate)
     func checkLocationServices(mapView: MKMapView, segueIdentifier: String, closure: ()->()){
           if CLLocationManager.locationServicesEnabled(){
              // setUpLocationManager() точность определения геопозиции
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAutorization(mapView: mapView, segueIdentifier: segueIdentifier)
            closure()
           }else {
               DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                   self.showAlert(title: "Location Server is Disabled",
                                  message: "To enable it go: Settings -> Privacy -> Locationvservices and turn ON")
               }
           }
       }
    //метод мониторинга статуса на рарешение использования геопозиции
    func checkLocationAutorization(mapView: MKMapView, segueIdentifier: String){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse: //приложению разрешенно использовать геолокацию
            mapView.showsUserLocation = true
            if segueIdentifier == "getAdress" { showUserLocation(mapView: mapView)}
            break
        case .denied: //отказано в доступе
            //показать AlertController
            break
        case .notDetermined: //статус не определен
            locationManager.requestWhenInUseAuthorization() // разрешение на авторизацию приложения на использование геолокации
            break
        case .restricted: //если приложение не авторизовано для использования геолокаций
            //Alert
            break
        case .authorizedAlways: //приложению разрешенно использовать геолокацию постоянно
            break
               @unknown default:
            print("all good")
        }
    }
    
    //Фокус карты на местоположении пользователя
    func showUserLocation(mapView: MKMapView) {
           //определяем координаты положения юзера
              if let location = locationManager.location?.coordinate {
                 //определяем регион
                  let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
                  
                  //отображаем регион на экране
                  mapView.setRegion(region, animated: true)
              }
       }
  
    //прокладка маршрута
    func getDirection(for mapView: MKMapView, previousLocation: (CLLocation) -> ()) {
        //определение координаты местоположения пользователя
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Error", message: "Current location is not found")
            return
        }
            //включение режимма отслеживания постоянного местоположения пользователя
            locationManager.startUpdatingLocation()
            // постройка маршрутов не реализовано!!!!
            previousLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
            
            //запрос на прокладку маршрута
            // присваиваем результат работы метода настройки маршрута
            guard let request = createDirectionRequest(from: location) else {
                showAlert(title: "Error", message: "Destination is not found")
                return
            }
            //создаем маршрут которые имеются в запросе
            let directions = MKDirections(request: request)
            
            //расчет маршрута, возвращение маршрута со всеми данными
            directions.calculate { (response, error) in
                if let error = error {
                    print(error)
                    return
                }
                //извлекаем обработанный маршрут
                guard let response = response else {
                    self.showAlert(title: "Error", message: "Маршрут недоступен")
                return }
                for route in response.routes{
                    mapView.addOverlay(route.polyline)
                    mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                    
                    //расстояние и время в пути
                    let distance = String(format: "%.1f", route.distance/1000)
                    let timeInterval = route.expectedTravelTime
                    
                    print("Расстояние до места \(distance) км")
                     print("Время в пути  \(timeInterval) сек")
                }
            }
            
        }
        
        //настройка маршрута для расчета маршрута
         func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request?{
              guard let destinationCoordinate = placeCoordinate else {return nil} //пердаем координаты заведения
              //определяем местоположение точки для начала маршрута
              let startingLocation = MKPlacemark(coordinate: coordinate)
              
              let destination = MKPlacemark(coordinate: destinationCoordinate)
              
              //маршрут от точки А до точки Б
              let request = MKDirections.Request()
              
              //подставляем начальную точку
              request.source = MKMapItem(placemark: startingLocation)
              //подставляем конечную точку
              request.destination = MKMapItem(placemark: destination)
              //тип транспорта
              request.transportType = .automobile
              request.requestsAlternateRoutes = true //позволяет строить альтернативные маршруты
              
              //после настройки параметров маршрута - возвращаем request
              return request
              
          }
          
        
    


    //метод для определения координат в центре отображаемой карты
  func getCenterLocation(for mapView: MKMapView) -> CLLocation {
          //константа для широты
          let latitude = mapView.centerCoordinate.latitude
          
          //константа для долготы
          let longitude = mapView.centerCoordinate.longitude
          
          //возвращаем координаты точки находящиеся по центру экрана
          return CLLocation(latitude: latitude, longitude: longitude)
      }
    
    
    private func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(okAction)
        
        //для доступа к методу present :
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true)
    }
    
}
