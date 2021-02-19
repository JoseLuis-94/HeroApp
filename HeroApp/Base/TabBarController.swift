//
//  TabBarController.swift
//  HeroApp
//
//  Created by Graciela Sarahi Guerra Castillo on 17/02/21.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = .white
        
        let tableVC = TableViewController()
        tableVC.tabBarItem = UITabBarItem(title: "Listado", image: nil, selectedImage: nil)
        
        let collectionVC = CollectionViewController()
        collectionVC.tabBarItem = UITabBarItem(title: "Grid", image: nil, selectedImage: nil)
        
        self.viewControllers = [tableVC, collectionVC]
    }
    
}
