//
//  DTImageScrollView.swift
//  DTImageScrollView
//
//  Created by Daron Tancharoen on 8/1/16.
//
//

import UIKit
import AlamofireImage

@objc public protocol DTImageScrollViewDatasource: AnyObject {
    func numberOfImages(in imageScrollView: DTImageScrollView) -> Int
    func imageScrollView(imageScrollView: DTImageScrollView, configurePhotoAt index: Int, withImageView imageView: UIImageView)
    @objc optional func imageScrollViewWillScroll(imageScrollView: DTImageScrollView)
    @objc optional func imageScrollView(imageScrollView: DTImageScrollView, didScrollTo index: Int)
}

open class DTImageScrollView: UIView, UIScrollViewDelegate {

    public let scrollView = UIScrollView()
    public let pageControl = UIPageControl()
    public var imageViews = [UIImageView]()
    
    public weak var datasource: DTImageScrollViewDatasource?
    
    public func show() {
        setup()
    }
    
    func setup() {
        // add scrollview
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.bounces = false
        self.scrollView.delegate = self
        self.addSubview(self.scrollView)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view":self.scrollView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view":self.scrollView]))
        
        // add page control
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.pageControl)
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.pageControl, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.pageControl, attribute: .bottom, multiplier: 1, constant: 0))
        
        // add photos
        reloadPhotos()
    }
    
    public func reloadPhotos() {
        // remove old ImageViews (if any)
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }
        self.imageViews.removeAll()
        
        // add photos to scrollView
        for index in 0..<self.datasource!.numberOfImages(in: self) {
            let imageView = UIImageView()
            imageView.tag = index+1
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            self.datasource?.imageScrollView(imageScrollView: self, configurePhotoAt: index, withImageView: imageView)
            self.scrollView.addSubview(imageView)
            self.imageViews.append(imageView)
            
            // add constraints
            // height
            self.scrollView.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1, constant: 0))
            // width
            self.scrollView.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: 1, constant: 0))
            // top
            self.scrollView.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .top, multiplier: 1, constant: 0))
            // bottom
            self.scrollView.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .bottom, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 0))
            if index == 0 {
                // left to scrollview
                self.scrollView.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .left, relatedBy: .equal, toItem: imageView, attribute: .left, multiplier: 1, constant: 0))
            } else {
                // left to right of previous view
                let previouseImageView = self.viewWithTag(index)!
                self.scrollView.addConstraint(NSLayoutConstraint(item: previouseImageView, attribute: .right, relatedBy: .equal, toItem: imageView, attribute: .left, multiplier: 1, constant: 0))
            }
            if index == self.datasource!.numberOfImages(in: self)-1 {
                // right to scrollview
                self.scrollView.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .right, relatedBy: .equal, toItem: imageView, attribute: .right, multiplier: 1, constant: 0))
            }
        }
        
        // update page control
        self.pageControl.numberOfPages = self.datasource!.numberOfImages(in: self) 
        self.pageControl.currentPage = 0
        
        // layoutIfNeeded()
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.datasource?.imageScrollViewWillScroll?(imageScrollView: self)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // update pageController
        let pageWidth = scrollView.frame.size.width
        let fractionalPage = Float(scrollView.contentOffset.x / pageWidth)
        let page = Int(roundf(fractionalPage))
        self.pageControl.currentPage = page
        self.datasource?.imageScrollView?(imageScrollView: self, didScrollTo: page)
    }
    
    public func scrollToImageAt(_ index: Int) {
        let pageWidth = Double(scrollView.frame.size.width)
        let pageX = pageWidth * Double(index)
        self.pageControl.currentPage = index
        self.datasource?.imageScrollView?(imageScrollView: self, didScrollTo: index)
        self.scrollView.setContentOffset(CGPoint(x: pageX, y: 0.0), animated: false)
    }
    
}


