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
    func imageScrollView(imageScrollView: DTImageScrollView, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
        let placeholderImage = index == 0 ? UIImage(named: "sample")! : UIImage(named: "placeholder3")!
        let url = URL(string: "http://www.boxzeed.com/wp-content/uploads/2015/09/1.1.3.jpg")!
        imageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
    }

    func numberOfImages(in imageScrollView: DTImageScrollView) -> Int {
        return 3
    }
}
