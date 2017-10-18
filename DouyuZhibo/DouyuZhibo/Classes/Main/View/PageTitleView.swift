//
//  PageTitleView.swift
//  DouyuZhibo
//
//  Created by 毛豆 on 2017/10/18.
//  Copyright © 2017年 毛豆. All rights reserved.
//

import UIKit

//暴露接口，HomeViewController实现该接口
protocol PageTitleViewDelegate : class {
    func pageTitleView(titleView : PageTitleView, selectedIndex index: Int)
}

fileprivate let kScrollLineHeight : CGFloat = 2
fileprivate let kNormalColor : (CGFloat,CGFloat,CGFloat) = (85, 85, 85)
fileprivate let kSelectedColor : (CGFloat,CGFloat,CGFloat) = (255, 128, 0)

class PageTitleView: UIView {
    //MARK: 定义属性
    fileprivate var currentIndex = 0
    fileprivate var titles: [String]
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    //代理属性设置为弱引用
    weak var delegate: PageTitleViewDelegate?
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    fileprivate lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    //MARK: 自定义构造函数
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: 设置UI属性
extension PageTitleView {
    fileprivate func setupUI() {
        addSubview(scrollView)
        scrollView.frame = bounds
        
        setupTitleLabels()
        
        //设置底线和滚动滑块
        setupBottomMenuAndScrollLine()
    }
    
    private func setupTitleLabels() {
        let labelWidth : CGFloat = frame.width / CGFloat(titles.count)
        let labelHeight: CGFloat = frame.height - kScrollLineHeight
        let labelY: CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
            let labelX: CGFloat = labelWidth * CGFloat(index)
            
            label.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func setupBottomMenuAndScrollLine() {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineHeight : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineHeight, width: frame.width, height: lineHeight)
        addSubview(bottomLine)
        
        guard let firstLabel = titleLabels.first else {
            return
        }
        firstLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineHeight, width: firstLabel.frame.width, height: kScrollLineHeight)
    }
}

extension PageTitleView {
    @objc fileprivate func titleLabelClick(tapGes: UITapGestureRecognizer) {
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        let oldLabel = titleLabels[currentIndex]
        
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        currentLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        
        currentIndex = currentLabel.tag
        
        let scrollLinePosition = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15, animations: { self.scrollLine.frame.origin.x = scrollLinePosition })
        
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}

extension PageTitleView {
    func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        let colorDelta = (kSelectedColor.0 - kNormalColor.0,kSelectedColor.1 - kNormalColor.1, kSelectedColor.2 - kNormalColor.2)
        
        sourceLabel.textColor = UIColor(r: kSelectedColor.0 - colorDelta.0 * progress, g: kSelectedColor.1 - colorDelta.1 * progress, b: kSelectedColor.2 - colorDelta.2 * progress)
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        currentIndex = targetIndex
    }
}
