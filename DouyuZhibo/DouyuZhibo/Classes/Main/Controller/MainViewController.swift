//
//  MainViewController.swift
//  DouyuZhibo
//
//  Created by 毛豆 on 2017/10/18.
//  Copyright © 2017年 毛豆. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    let names: [String] = ["Home","Live","Follow","Explore","Profile"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in names {
            addChildVc(storyName: item)
        }
    }
    
    private func addChildVc(storyName: String){
        let vc = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        addChildViewController(vc)
    }

}
