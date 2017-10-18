//
//  RecommendViewController.swift
//  DouyuZhibo
//
//  Created by 毛豆 on 2017/10/19.
//  Copyright © 2017年 毛豆. All rights reserved.
//

import UIKit

fileprivate let kItemMargin : CGFloat = 10
fileprivate let kItemWidth = (kScreenWidth - 3 * kItemMargin) / 2
fileprivate let kItemHeight = kItemWidth * 3 / 4
fileprivate let kHeaderViewHeight : CGFloat = 50
fileprivate let kNormalCellId = "normal"
fileprivate let kHeaderViewId = "header"

class RecommendViewController: UIViewController {
    //MARK: 懒加载属性
    fileprivate lazy var collectionView: UICollectionView = { [unowned self] in
        // 创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemWidth, height: kItemHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: kScreenWidth, height: kHeaderViewHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        //创建UICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.blue
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kNormalCellId)
        
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewId)
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        return collectionView
    }()
    
    
    //MARK: 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

extension RecommendViewController {
    fileprivate func setupUI() {
        view.addSubview(collectionView)
    }
}

extension RecommendViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellId, for: indexPath)
        cell.backgroundColor = UIColor.red
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewId, for: indexPath)
        headerView.backgroundColor = UIColor.black
        
        return headerView
    }
}
