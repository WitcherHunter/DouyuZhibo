//
//  PageContentView.swift
//  DouyuZhibo
//
//  Created by 毛豆 on 2017/10/18.
//  Copyright © 2017年 毛豆. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate: class {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}

fileprivate let contentCellId = "contentCellId"

class PageContentView: UIView{
    
    //MARK: 定义属性
    fileprivate var childViewControllers: [UIViewController]
    fileprivate weak var parentViewController: UIViewController?
    fileprivate var startOffsetX: CGFloat = 0
    
    fileprivate var isForbidScrollDelegate = false
    weak var delegate : PageContentViewDelegate?
    
    fileprivate lazy var collectionView: UICollectionView = { [weak self] in
        //创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //创建collectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCellId)
        collectionView.delegate = self
        
        return collectionView
    }()

    init(frame: CGRect, childViewControllers: [UIViewController], parentViewController: UIViewController?) {
        self.childViewControllers = childViewControllers
        self.parentViewController = parentViewController
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageContentView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = true
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isForbidScrollDelegate {
            return
        }
        
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.bounds.width
        if currentOffsetX > startOffsetX {
            //左滑
            progress = currentOffsetX / scrollViewWidth - floor(currentOffsetX / scrollViewWidth)
            
            sourceIndex = Int(currentOffsetX / scrollViewWidth)
            
            targetIndex = sourceIndex + 1
            if targetIndex >= childViewControllers.count {
                targetIndex = childViewControllers.count - 1
            }
            
            if currentOffsetX - startOffsetX == scrollViewWidth {
                progress = 1
                targetIndex = sourceIndex
            }
        } else {
            //右滑
            progress = 1 - (currentOffsetX / scrollViewWidth - floor(currentOffsetX / scrollViewWidth))
            
            targetIndex = Int(currentOffsetX / scrollViewWidth)
            
            sourceIndex = targetIndex + 1
            
            if sourceIndex >= childViewControllers.count {
                sourceIndex = childViewControllers.count - 1
            }
            
            if startOffsetX - currentOffsetX == scrollViewWidth {
                progress = 1
                sourceIndex = targetIndex
            }
        }
        
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}


extension PageContentView {
    fileprivate func setupUI() {
        //添加子控制器
        for child in childViewControllers {
            parentViewController?.addChildViewController(child)
        }
        
        //添加UICollectionView用于在Cell中存放控制器的View
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

extension PageContentView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellId, for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVc = childViewControllers[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

extension PageContentView {
    func setupCurrentIndex(currentIndex: Int) {
        
        isForbidScrollDelegate = true
        
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x : offsetX, y: 0), animated: false)
    }
}
