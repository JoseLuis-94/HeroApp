//
//  CollectionViewController.swift
//  HeroApp
//
//  Created by Graciela Sarahi Guerra Castillo on 18/02/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class CollectionViewController: UIViewController {
    
    var url = ""
    var urlb = "https://superheroapi.com/api/10156112965520834/"
    var arr = [String]()
    var img = [String]()
    var nam = [String]()
    var occ = [String]()
    var id = [String]()
    var pos = 0
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        search.delegate = self
        
        load()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellcollection", for: indexPath) as! CollectionViewCell
        cell.label.text = arr[indexPath.row]
        
        //cell.imageView?.load(url: NSURL(string: img[indexPath.row]) as! URL)
        cell.imageView?.image = .none
        if cell.imageView?.load(url: NSURL(string: img[indexPath.row]) as! URL) != nil{
            cell.imageView?.load(url: NSURL(string: img[indexPath.row]) as! URL)
        }else{
            cell.imageView?.image = .none
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellcollection", for: indexPath) as! CollectionViewCell
        pos = indexPath.row
        performSegue(withIdentifier: "collectionmodal", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionmodal"{
            var detail = segue.destination as! DetailViewController
            detail.hn = arr[pos]
            detail.rn = nam[pos]
            detail.oc = occ[pos]
            detail.urlimg = img[pos]
        }
    }
}

extension CollectionViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        arr.removeAll()
        img.removeAll()
        nam.removeAll()
        occ.removeAll()
        search(character: search.text!)
        search.text = ""
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search.text = ""
        view.endEditing(true)
    }
}

extension CollectionViewController{
    func load() {
        url = urlb + "search/ant"
        
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
            self.collectionView.reloadData()
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
            self.collectionView.reloadData()
        }
    }
}
