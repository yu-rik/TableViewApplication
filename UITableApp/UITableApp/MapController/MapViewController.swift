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
   //свойсттво типа протокола MapViewControllerDelegate
    var mapViewControllerDelegate: MapViewControllerDelegate?
    
    //для управления действиями с местоположением пользователя создаем экземпляр класса CLLocationManager()
    let locationManager = CLLocationManager()
    
    let regionInMeters = 5_000.00
    
    
    var place = Place()
    
    //уникальный идентификатор
    let annotationIdentifier = "annotationIdentifier"
    
    var incomeSegueIdentifier = "" //идентификатор segue - для вызова того или другого segue
    
    //свойство принимающее координаты заведения
    var placeCoordinate: CLLocationCoordinate2D?
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var adrressLabel: UILabel!
    @IBOutlet weak var mapPinImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBAction func goButtonPressed() {
        getDirection()
    }
    
    
    @IBAction func Close() {
        dismiss(animated: true) // метод закрывает ViewController  и выгружает его из памяти
    }
    @IBAction func centerVviewInUserLocation() {
           showUserLocation() // позиционирование карты по местоположению пользователя
    }
    
    @IBAction func doneButtonPresed() {
        mapViewControllerDelegate?.getAddress(adrressLabel.text) //передача в getAddress-протокола текущее значение адреса
        dismiss(animated: true) //после передачи данных закрытие viewController
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adrressLabel.text = ""
        //подписываем делегата ответственного за выполнения методов протокола MKMapViewDelegate
        //или в storyboard перетянуть лучиком от mapView к mapViewController  и выбрать delegate
        mapView.delegate = self
       
        setupMapView()
        
        checkLocationServices()

        
    }
    private func setupMapView() {
        goButton.isHidden = true
        
        if incomeSegueIdentifier == "showMap" {
            
            setUpMark() //вызов метода при переходе на viewController и позиционирование карты по местоположению заведения
            mapPinImage.isHidden = true //скрываем маркер с карты расположения заведения
            adrressLabel.isHidden = true
            doneButton.isHidden = true
            goButton.isHidden = false
        }
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
                //передача координат placemarkLocation свойству placeCoordinate
                self.placeCoordinate = placemarkLocation.coordinate
                
                
                //задаем видимую область карты - чтоб были видны все созданные аннотации
                self.mapView.showAnnotations([annotation], animated: true)
                
                //выделяем созданную аннотацию на карте
                self.mapView.selectAnnotation(annotation, animated: true)
            }
        }
        
        
        
    }


    // проверка включены ли службы геолокации
    private func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManager()
            checkLocationAutorization()
        }else {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.showAlert(title: "Location Server is Disabled",
                               message: "To enable it go: Settings -> Privacy -> Locationvservices and turn ON")
            }
        }
    }
    
    private func setUpLocationManager(){
        //чтоб отрабатывался метод протокола CLLocationManagerDelegate назначаем делегат
        locationManager.delegate = self
        
        //точность определения местоположения пользователя
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    //прокладка маршрута
    private func getDirection(){
        //определение координаты местоположения пользователя
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Error", message: "Current location is not found")
            return
        }
        
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
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                //расстояние и время в пути
                let distance = String(format: "%.1f", route.distance/1000)
                let timeInterval = route.expectedTravelTime
                
                print("Расстояние до места \(distance) км")
                 print("Время в пути  \(timeInterval) сек")
            }
        }
        
    }
    
    //настройка маршрута
    private func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request?{
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
    
    
    //метод мониторинга статуса на рарешение использования геопозиции
    private func checkLocationAutorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse: //приложению разрешенно использовать геолокацию
            mapView.showsUserLocation = true
            if incomeSegueIdentifier == "getAdress" {showUserLocation()}
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
    
    private func showUserLocation() {
        //определяем координаты положения юзера
           if let location = locationManager.location?.coordinate {
              //определяем регион
               let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
               
               //отображаем регион на экране
               mapView.setRegion(region, animated: true)
           }
    }

    //метод для определения координат в центре отображаемой карты
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
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
        present(alert, animated: true)
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
        let center = getCenterLocation(for: mapView)
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
        checkLocationAutorization()
    }
}
