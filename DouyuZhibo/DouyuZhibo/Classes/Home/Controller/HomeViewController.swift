//
//  HomeViewController.swift
//  DouyuZhibo
//
//  Created by 毛豆 on 2017/10/18.
//  Copyright © 2017年 毛豆. All rights reserved.
//

import UIKit

private let kTitleViewHeight: CGFloat = 40

class HomeViewController: UIViewController{
   
    fileprivate lazy var pageTitleView: PageTitleView = {
        let titleFrame = CGRect(x: 0, y: kStatusBarHeight + kNavigationBarHeight, width: kScreenWidth, height: kTitleViewHeight)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    fileprivate lazy var pageContentView: PageContentView = { [weak self] in
        let contentHeight = kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTitleViewHeight - kTabBarHeight
        let contentFrame = CGRect(x: 0, y: kStatusBarHeight + kNavigationBarHeight + kTitleViewHeight, width: kScreenWidth, height: contentHeight)
        
        var childViewControllers = [UIViewController]()
        childViewControllers.append(RecommendViewController())
        for _ in 0..<4 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childViewControllers.append(vc)
        }
        let contentView = PageContentView(frame: contentFrame, childViewControllers: childViewControllers, parentViewController: self)
        contentView.delegate = self
        return contentView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

extension HomeViewController : PageTitleViewDelegate {
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setupCurrentIndex(currentIndex: index)
    }
}

extension HomeViewController : PageContentViewDelegate {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

//MARK: 设置UI界面
extension HomeViewController {
    fileprivate func setupUI() {
        //不需要调整UIScrollView内边距
        automaticallyAdjustsScrollViewInsets = false
        
        //设置导航栏
        setupNavigationBar()
        
        //添加TitleView
        view.addSubview(pageTitleView)
        
        //添加contentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.purple
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
        //设置左侧item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        //设置右侧item
        let size = CGSize(width: 40, height: 40)

        let historyItem = UIBarButtonItem(imageName: "viewHistoryIcon", highlightedImageName: "viewHistoryIconHL", size: size)
        
        let searchItem = UIBarButtonItem(imageName: "searchBtnIcon", highlightedImageName: "searchBtnIconHL", size: size)
        
        let qrcodeItem = UIBarButtonItem(imageName: "scanIcon", highlightedImageName: "scanIconHL", size: size)
        
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
    }
}
