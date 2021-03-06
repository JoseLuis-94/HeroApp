//
//  ViewController.swift
//  HeroApp
//
//  Created by Graciela Sarahi Guerra Castillo on 17/02/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    var url = ""
    var urlb = "https://superheroapi.com/api/10156112965520834/"
    var arr = [String]()
    var img = [String]()
    var nam = [String]()
    var occ = [String]()
    var pos = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchbar.delegate = self
        
        load()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celltable") as! TableViewCell
        cell.label.text = arr[indexPath.row]
        
        cell.imgView?.image = .none
        if cell.imgView?.load(url: NSURL(string: img[indexPath.row]) as! URL) != nil{
            cell.imgView?.load(url: NSURL(string: img[indexPath.row]) as! URL)
        }else{
            cell.imgView?.image = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        pos = indexPath.row
        performSegue(withIdentifier: "tablemodal", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tablemodal"{
            var detail = segue.destination as! DetailViewController
            detail.hn = arr[pos]
            detail.rn = nam[pos]
            detail.oc = occ[pos]
            detail.urlimg = img[pos]
        }
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        arr.removeAll()
        img.removeAll()
        nam.removeAll()
        occ.removeAll()
        search(character: searchbar.text!)
        searchbar.text = ""
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchbar.text = ""
        view.endEditing(true)
    }
}

extension ViewController{
    func load(){
        url = urlb + "search/a"
        
        AF.request(url).responseJSON{(response) -> Void in
            if response.value != nil {
                if let data = response.data {
                    if let json = try? JSON(data: data) {
                        for item in json["results"].arrayValue {
                            self.arr.append(item["name"].stringValue)
                            self.img.append(item["image"]["url"].stringValue)
                            self.nam.append(item["biography"]["full-name"].stringValue)
                            self.occ.append(item["work"]["occupation"].stringValue)
                        }
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func search(character : String){
        url = urlb + "search/" + character
        
        if character.contains(" "){
            let newcharacter = character.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            url = urlb + "search/" + newcharacter
        }
        
        AF.request(url).responseJSON{(response) -> Void in
            //if response.value != nil {
                if let data = response.data {
                    if let json = try? JSON(data: data) {
                        for item in json["results"].arrayValue {
                            self.arr.append(item["name"].stringValue)
                            self.img.append(item["image"]["url"].stringValue)
                            self.nam.append(item["biography"]["full-name"].stringValue)
                            self.occ.append(item["work"]["occupation"].stringValue)
                        }
                    }
                }
            //}
            self.tableView.reloadData()
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
