//
//  DetailViewController.swift
//  Vacays
//
//  Created by mac on 2019/11/8.
//  Copyright © 2019 ydu1717. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    private lazy var img : UIImageView = {
        let img = UIImageView.init()
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private lazy var titlelb : UILabel = {
        let lb = UILabel.init()
        lb.textAlignment = NSTextAlignment.center
        return lb
    }()
    
    private lazy var locationlb : UILabel = {
        let lb = UILabel.init()
        lb.textAlignment = NSTextAlignment.center
        return lb
    }()
    
    private lazy var costlb : UILabel = {
        let lb = UILabel.init()
        lb.textAlignment = NSTextAlignment.center
        return lb
    }()
    
    private lazy var datelb : UILabel = {
        let lb = UILabel.init()
        lb.textAlignment = NSTextAlignment.center
        return lb
    }()
    
    private lazy var remarklb : UITextView = {
        let lb = UITextView.init()
        lb.textAlignment = NSTextAlignment.center
        lb.delegate = self
        return lb
    }()

//    func configureView() {
//        // Update the user interface for the detail item.
//        if let detail = detailItem {
//            if let label = detailDescriptionLabel {
//                label.text = detail.description
//            }
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        configureView()
        
        view.addSubview(self.img)
        self.img.frame = CGRect.init(x: 0, y:CGFloat(NavigationHeight) , width:SCREEN_WIDTH , height: SCREEN_WIDTH)
        
        view.addSubview(self.titlelb)
        self.titlelb.frame = CGRect.init(x: 0, y: self.img.y + self.img.height + 5, width: SCREEN_WIDTH, height: 20)
        
        view.addSubview(self.locationlb)
        self.locationlb.frame = CGRect.init(x: 0, y: self.titlelb.y + self.titlelb.height + 5, width: SCREEN_WIDTH, height: 20)
        
        view.addSubview(self.costlb)
        self.costlb.frame = CGRect.init(x: 0, y: self.locationlb.y + self.locationlb.height + 5, width: SCREEN_WIDTH, height: 20)
        
        view.addSubview(self.datelb)
        self.datelb.frame = CGRect.init(x: 0, y: self.costlb.y + self.costlb.height + 5, width: SCREEN_WIDTH, height: 20)
        
        view.addSubview(self.remarklb)
        self.remarklb.frame = CGRect.init(x: 0, y: self.datelb.y + self.datelb.height + 5, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.datelb.y - 50)
        
        self.img.backgroundColor = UIColor.red
        self.titlelb.text    = "sdsd"
        self.locationlb.text = "sdsdds"
        self.costlb.text     = "ssdsds"
        self.datelb.text     = "sdsd"
        self.remarklb.text   = "sdsd"


    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -SCREEN_HEIGHT/2)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.remarklb.resignFirstResponder()
    }
    

    var detailItem: NSDate? {
        didSet {
            // Update the view.
//            configureView()
        }
    }


}

