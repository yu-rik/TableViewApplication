//
//  MainViewController.swift
//  UITableApp
//
//  Created by yurik on 6/4/20.
//  Copyright © 2020 yurik. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //создаем экземпляр класса UISearchController для работы с поиском и отображением информации на том же View
    private let searchController = UISearchController(searchResultsController: nil)
    
   //создаем объект класса Results(тип библиотеки Realm, аналог массива) для запроса к базе и отображения ее данных в интерфейсе
   private var places : Results<Place>!
    
    //создаем массив куда будем присваивать отфильтрованные записи для отображения поискового запроса
    private var filteredPlaces: Results<Place>!
    
    //свойство для отображения true или false в зависимости является ли строка пустой
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    
    //для отслеживания активации поискового запроса - возвращает true  если поисковая строка активирована и не пустая
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    //создаем свойство для создания сортировки по возрастанию
    var ascendingSorting = true //по умолчанию сортировка по возрастанию
    
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var segmentedControl: UISegmentedControl!
   @IBOutlet weak var reverseSortingButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // отображение данных на экране при запуске приложения
        //делаем запрос объектов из realm инициализируя свойства places
        places = realm.objects(Place.self) // под Place имеется ввиду тип данных
        
        //настройка параметров объекта UISearchControllera
        searchController.searchResultsUpdater = self //получатель информации об изменении текста в поисковой строке будет данный класс MainView
        searchController.obscuresBackgroundDuringPresentation = false //возможность просматривать и редактировать выбранное (true -не дает такой возможности)
        searchController.searchBar.placeholder = "Search" // название поисковой строки
        navigationItem.searchController = searchController //строка поиска интегрирована в navigationBar
        definesPresentationContext = true // позволяет отпустить строку поиска при переходе на другой экран
        
      
    }

    // MARK: - Table view data source

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {  //если поисковая строка не пустая
            return filteredPlaces.count  //возвращает количество элементов отфильтрованного массива
        }
      // return places.count верно!!!
        return places.isEmpty ? 0 : places.count //если база пуста - возвращаем ноль
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Jacheyka", for: indexPath) as! CustomTableViewCell
       //---------------------- заполнение полей ячейки ----------------start
        
        //создание экземпляра модели для присваивания ему значения из массива filteredPlaces или массива places
      //с помощью тернарного оператора
        // let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
        var place = Place()
        if isFiltering {
            place = filteredPlaces[indexPath.row]
        }else {
            place = places[indexPath.row]
        }
                
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        
        //отображение звезд рэйтинга на главном экране
        cell.cosmosView.rating = place.raitinG
        
        //----------------------------------- end
            

        return cell
    }
     
    
    // MARK: - TableViewDelegate
     //метод возвращает высоту строки, если выcоту строки указывать в storyboard, то этот метод не нужен
    //override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     //   return 85
   // }
    //метод который убирает выделение ячейки при возврате с View на главный View
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //метод протокола TableViewDelegate, который позволяет вызывать свайпом справа -налево другие методы
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StorageManager.deleteObject(places[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade )
        }
    }
    

    
    
    
    
   
    // MARK: - Navigation

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            //определяем индекс выбранной ячейки
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
           
            //создание экземпляра модели для присваивания ему значения из массива filteredPlaces или массива places
          // через тернарный оператор let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
            
            
            let place: Place
                   if isFiltering {
                       place = filteredPlaces[indexPath.row]
                   }else {
                       //извлекаем объект из массива places по полученному индексу ячейки
                       place = places[indexPath.row]
                   }
           
            //экземпляр NewPlaceViewControllera с помощью которого будем передавать данные на NewPlaceViewController
            let newPlaceVC = segue.destination as! NewPlaceViewController
           
            // передаем place на newPlaceVC
            newPlaceVC.currentPlace = place
        }
    }
    
    
    //связь кнопки Save с unwindSegue
 @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
    //создаем экземпляр класса NewPlaceViewController с извлечением опционала через guard
    guard let newPlaceVC = segue.source as? NewPlaceViewController else {return} //с помощью .source получаем данные и приводим их к типу NewPlaceViewController
    newPlaceVC.savePlace() //вызов метода-добавления значений в модель из класса NewPlaceViewController
    tableView.reloadData() // обновление интерфейса
    
    }
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        //сортировка в зависимости от нажатой кнопки
//        if sender.selectedSegmentIndex == 0 {
//            places = places.sorted(byKeyPath: "date")
//        }else {
//            places = places.sorted(byKeyPath: "name")
//        }
//        tableView.reloadData()
       sorting()
    }
    @IBAction func reverseSorting(_ sender: UIBarButtonItem) {
        ascendingSorting.toggle() //меняем значение ascendingSorting на противоположное
        if ascendingSorting {
            reverseSortingButton.image = #imageLiteral(resourceName: "AZ") // меняем значение изображения для кнопки (аутлет кнопки бар-Айтем)
        } else {
            reverseSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
    }
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        }else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
}
extension MainViewController : UISearchResultsUpdating{
   // метод вызывается при тапе по поисковой строке
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!) //в параметрах значение из поисковой строки
    }
    //фильтрация контента в соответствии с поисковым запросом
    private func filterContentForSearchText(_ searchText: String) {
        //заполнение массива filterdPlaces отфильтрованными данными основного массива базыданных
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        tableView.reloadData()
    }
    
}
