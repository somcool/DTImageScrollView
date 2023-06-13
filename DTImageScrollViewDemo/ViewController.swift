//
//  ViewController.swift
//  DTImageScrollViewDemo
//
//  Created by Daron Tancharoen on 8/1/16.
//
//

import UIKit
import AlamofireImage

class ViewController: UIViewController {

    @IBOutlet weak var imageScrollView: DTImageScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.imageScrollView.datasource = self
        self.imageScrollView.show()
    }
}

// MARK: - DTImageScrollViewDatasource

extension ViewController: DTImageScrollViewDatasource {
    
    func imageScrollView(imageScrollView: DTImageScrollView, placeholderImageFor index: Int) -> UIImage {
        if index == 0 {
            return UIImage(named: "sample")!
        } else {
            return UIImage(named: "placeholder3")!
        }
    }
    
    func imageScrollView(imageScrollView: DTImageScrollView, imageURLAt index: Int) -> URL {
        return URL(string: "http://www.boxzeed.com/wp-content/uploads/2015/09/1.1.3.jpg")!
    }
    
    func numberOfImages(in imageScrollView: DTImageScrollView) -> Int {
        return 3
    }
}
