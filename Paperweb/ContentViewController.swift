//
//  ContentViewController.swift
//  Papaerweb
//
//  Created by 蓝昭辰 on 2019/5/19.
//  Copyright © 2019 UTS. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    let length: Int = 300;
    var currentPage: Int = 0;
    var totalPage: Int = 0;
    var textContent: String = ""

    var paperwebId: Int?
    var bg: Int = 1
    var textSize: Int = 2

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var label1: UILabel!

    @IBOutlet weak var touchView: UIView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var settingView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        label1.text = String(paperwebId!)

        textContent = Database().getContent(id: paperwebId!)//根据ID从数据库获取该纸网页的内容并置入页面
        let key: String = "page+" + String.init(format: "%d", paperwebId!);
        currentPage = (UserDefaults.standard.value(forKey: key) ?? 0) as! Int ;

        totalPage = textContent.count / length + 1;

        changeContent()

        bg = (UserDefaults.standard.value(forKey: "backgroundColor") ?? 1) as! Int
        if(bg == 1) {
            whiteBackground(self)
        }else if(bg==2){
            blackBackground(self)
        }else if(bg==3){
            paperBackground(self)
        }
        
        textSize = (UserDefaults.standard.value(forKey: "textSize") ?? 2) as! Int
        if(textSize==1){
            littleFont(self)
        }else if (textSize==2){
            mediaFont(self)
        }else if(textSize==3){
            bigFont(self)
        }

        // Do any additional setup after loading the view.
        //settingView.isHidden = true
        self.view.bringSubviewToFront(touchView)
        self.view.bringSubviewToFront(settingView)
        self.view.bringSubviewToFront(backButton)
    }


//    @IBAction func lastPage(_ sender: Any) {
//        if currentPage == 0 {
//            return;
//        }
//        currentPage = currentPage - 1
//        changeContent()
//
//
//    }
//
//    @IBAction func NextPage(_ sender: Any) {
//        if currentPage == totalPage-1 {
//            return;
//        }
//        currentPage = currentPage + 1
//        changeContent()
//
//    }



    func changeContent() {

        let start = textContent.index(textContent.startIndex, offsetBy: length * currentPage);
        var newStr = "";
        if textContent.count < length * (currentPage + 1) {
            let end = textContent.index(textContent.startIndex, offsetBy: textContent.count);
            newStr = String(textContent[start..<end])
        } else {
            let end = textContent.index(textContent.startIndex, offsetBy: length * (currentPage + 1));
            newStr = String(textContent[start..<end])
        }


        textView.text = newStr;



    }


    @IBAction func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "back", sender: backButton)
        let key: String = "page+" + String.init(format: "%d", paperwebId!);
        UserDefaults.standard.set(currentPage, forKey: key);

        UserDefaults.standard.set(bg, forKey: "backgroundColor")
        UserDefaults.standard.set(textSize, forKey: "textSize")

        UserDefaults.standard.synchronize();
    }


//    @IBAction func setting(_ sender: Any) {
//        settingView.isHidden = false
//        self.view.bringSubviewToFront(touchView)
//        self.view.bringSubviewToFront(settingView)
//
//
//    }



//    @IBAction func addLab(_ sender: Any) {
//        let key:String = "page+" + String.init(format: "%d", paperwebId!);
//
//        UserDefaults.standard.set(currentPage, forKey: key);
//        UserDefaults.standard.synchronize();
//    }


    @IBAction func whiteBackground(_ sender: Any) {
        backgroundView.backgroundColor = UIColor.white
        textView.textColor = UIColor.black
        label1.textColor = UIColor.black
        backgroundView.layer.contents = nil
        bg = 1
    }

    @IBAction func blackBackground(_ sender: Any) {
        backgroundView.backgroundColor = UIColor.black
        textView.textColor = UIColor.white
        label1.textColor = UIColor.white
        backgroundView.layer.contents = nil
        bg = 2
    }

    @IBAction func paperBackground(_ sender: Any) {
        textView.textColor = UIColor.black
        label1.textColor = UIColor.black
        backgroundView.layer.contents = UIImage(named: "img/bg1.jpg")!.cgImage
        bg = 3
    }

    @IBAction func littleFont(_ sender: Any) {
        label1.font = UIFont.systemFont(ofSize: 10);
        textView.font = UIFont.systemFont(ofSize: 10);
        textSize = 1
    }

    @IBAction func mediaFont(_ sender: Any) {
        label1.font = UIFont.systemFont(ofSize: 17);
        textView.font = UIFont.systemFont(ofSize: 17);
        textSize = 2
    }

    @IBAction func bigFont(_ sender: Any) {
        label1.font = UIFont.systemFont(ofSize: 28);
        textView.font = UIFont.systemFont(ofSize: 28);
        textSize = 3
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("jinle")
        let point = touches.first!.location(in: touchView)
        print(point.x, point.y)
        if(settingView.isHidden && point.x > backgroundView.frame.maxX / 3 && point.x < backgroundView.frame.maxX / 3 * 2) {
            settingView.isHidden = false
        } else if (settingView.isHidden == false && point.y < settingView.frame.minY) {
            settingView.isHidden = true
        } else if(settingView.isHidden && point.x < backgroundView.frame.maxX / 3) {
            if currentPage == 0 {
                return;
            }
            currentPage = currentPage - 1
            changeContent()
        } else if(settingView.isHidden && point.x > backgroundView.frame.maxX / 3 * 2) {
            if currentPage == totalPage-1 {
                return;
            }
            currentPage = currentPage + 1
            changeContent()
        }
    }

}


