//
//  Scroll.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/30.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Specifies the screen display size of the scrollView.
        scrollView = UIScrollView(frame: CGRect(x: 0, y:20, width: self.view.frame.size.width, height: self.view.frame.size.height-150))
        // Specify the size of the scrollView (width is the width of the View displayed in one menu x number of pages).
        scrollView.contentSize = CGSize(width: self.view.frame.size.width*3, height: self.view.frame.size.height-250)
        // Become a delegate of scrollView.
        scrollView.delegate = self
        // Enables scrolling of menu units
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        // Hide horizontal scroll indicator
        scrollView.showsHorizontalScrollIndicator = false
        // bounces
        scrollView.bounces = false
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.white
        // Add a UIImageView on the scrollView for a page (3 pages in this case).
        let imageView1 = createImageView(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-150, image: "photo")
        scrollView.addSubview(imageView1)
        
        let imageView2 = createImageView(x: self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-150, image: "photo")
        scrollView.addSubview(imageView2)
        
        let imageView3 = createImageView(x: self.view.frame.size.width*2, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-150, image: "photo")
        scrollView.addSubview(imageView3)
        
        // Setting the display position and size of the pageControl.
        pageControl = UIPageControl(frame: CGRect(x: 0, y: scrollView.bottom, width: self.view.frame.size.width, height: 30))
        // Set the number of pages in pageControl.
        pageControl.numberOfPages = 3
        // Colour of the dots on pageControl.
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        // Colour of the dot on the current page in pageControl
        pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    // Generate UIImageView
    func createImageView(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, image: String) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        let image = UIImage(named:  image)
        imageView.image = image
        return imageView
    }
    // Configuring scrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
