//
//  DetailViewController.swift
//  HeroApp
//
//  Created by Graciela Sarahi Guerra Castillo on 18/02/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var heroname: UILabel!
    @IBOutlet weak var realname: UILabel!
    @IBOutlet weak var occupation: UILabel!
    
    var hn = ""
    var rn = ""
    var oc = ""
    var urlimg = ""
    
    var url = ""
    var urlb = "https://superheroapi.com/api/10156112965520834/"
    var arr = [String]()
    var img = [String]()
    var nam = [String]()
    var occ = [String]()
    var temp = [UIImage]()
    var pos = 0
    
    fileprivate let carousel: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CarouselCell.self, forCellWithReuseIdentifier: "celldetail")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        heroname.text = hn
        realname.text = rn
        occupation.text = oc
        image.load(url: NSURL(string: urlimg) as! URL)
        
        
        view.addSubview(carousel)
        carousel.backgroundColor = .white
        carousel.topAnchor.constraint(equalTo: view.topAnchor, constant: 500).isActive = true
        carousel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        carousel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        carousel.heightAnchor.constraint(equalTo: carousel.widthAnchor , multiplier: 0.5).isActive = true
        
        carousel.delegate = self
        carousel.dataSource = self
        
        load()
    }
}

extension DetailViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3.5, height: collectionView.frame.width/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celldetail", for: indexPath) as! CarouselCell
        cell.backgroundColor = .lightGray
        let data = try? Data(contentsOf: NSURL(string: img[indexPath.row])! as URL)
        if data != nil {
            cell.bg.image = UIImage(data: data!)
        }else{
            cell.bg.image = .none
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        heroname.text = arr[indexPath.row]
        realname.text = nam[indexPath.row]
        occupation.text = occ[indexPath.row]
        image.image = .none
        if image.load(url: NSURL(string: img[indexPath.row]) as! URL) != nil{
            image.load(url: NSURL(string: img[indexPath.row]) as! URL)
        }else{
            image.image = .none
        }
    }
}

extension DetailViewController{
    func load(){
        
        arr.removeAll()
        img.removeAll()
        nam.removeAll()
        occ.removeAll()
        
        url = urlb + "search/" + hn.prefix(2)
        AF.request(url).responseJSON{(response) -> Void in
            if response.value != nil {
                if let data = response.data {
                    if let json = try? JSON(data: data) {
                        for item in json["results"].arrayValue {
                            if self.arr.count <= 10 {
                                self.arr.append(item["name"].stringValue)
                                self.nam.append(item["biography"]["full-name"].stringValue)
                                self.occ.append(item["work"]["occupation"].stringValue)
                                self.img.append(item["image"]["url"].stringValue)
                                
                                DispatchQueue.global().async { [weak self] in
                                    if let data = try? Data(contentsOf: NSURL(string: item["image"]["url"].stringValue) as! URL) {
                                        if let image = UIImage(data: data) {
                                            self?.temp.append(image)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            self.carousel.reloadData()
        }
    }
}

class CarouselCell:UICollectionViewCell{
    
    fileprivate let bg : UIImageView = {
        let iv = UIImageView()
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        contentView.addSubview(bg)
        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
