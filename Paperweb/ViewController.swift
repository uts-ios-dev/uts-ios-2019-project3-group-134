//
//  ViewController.swift
//  Papaerweb
//
//  Created by 蓝昭辰 on 2019/5/18.
//  Copyright © 2019 UTS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var desk: UIScrollView!
    var paperwebs:[Paperweb] = []
    var paperwebsSearch:[Paperweb] = []
    var paperwebsButtons:[UIButton] = []  //
    var paperwebsTitles:[UILabel] = []    //
    var searchDid: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //obtain share extension content
        //let userDefault = UserDefaults.standard
        //userDefault.addSuite(named: "group.Paperweb")
        let userDefault = UserDefaults(suiteName: "group.Paperweb")
        print("before")
        var i = 0
        var key = "paperweb"+String(i)
        while(true){
            key = "paperweb"+String(i)
            if((userDefault?.object(forKey: key)) != nil){
                if let dict = userDefault!.value(forKey: key) as? NSDictionary{
                    print("jinle")
                    let title = dict.value(forKey: "title") as! String
                    let content = dict.value(forKey: "content") as! String
                    
                    userDefault!.removeObject(forKey: key)
                    print("Removed key: ",key)
                    userDefault!.synchronize()
                    print(title,content)
                    addPaperweb(title: title, content: content, index: 0, id: Database().getPaperwebsNum()+1)
                }
                i = i + 1
            } else {
                break
            }
        }
        
        
        print("after")
        
        // Do any additional setup after loading the view.
        desk.isScrollEnabled = true
        desk.contentSize = CGSize(width: 374,height: 150);
        
        //testAddPaperwebs(number:24)
        
        

        //Database().deletePaperweb(id:13)
        //删除指定id的纸网页，id从1开始计算，不能超出当前纸网页的数量，否则报错
        
        paperwebs = Database().getPaperwebs()
        setPaperwebs(paperwebs: paperwebs)
    }

    @objc func tapped(sender: UIButton) {//每一个纸网页被点击后触发，获取到它们的id,然后跳转到内容页面
        self.performSegue(withIdentifier: "ShowDetailView", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {//在这个方法中给新页面传递参数,此处传递到的是纸网页id
        if segue.identifier == "ShowDetailView"{
            let controller = segue.destination as! ContentViewController
            controller.paperwebId = (sender as! UIButton).tag
        }
    }
    
    func setPaperwebs(paperwebs:[Paperweb]) {//将所有纸网页放置入当前view,页面刷新时会被调用
        
        var paperwebsY = 0
        var horizontalNum  = 0
        
        for i in 0..<paperwebs.count {
            
            let btn = UIButton(frame: CGRect(x: horizontalNum * 110, y: paperwebsY, width: 100, height: 120))
            btn.setImage(UIImage(named: "paperweb"), for: UIControl.State.normal)
            btn.addTarget(self, action: #selector(tapped), for: .touchUpInside)
            btn.tag = paperwebs[i].id
            self.desk.addSubview(btn)
            paperwebsButtons.append(btn)  //
            
            let title = UILabel(frame: CGRect(x: horizontalNum * 110, y: paperwebsY + 70, width: 100, height: 120))
            title.text = paperwebs[i].title
            self.desk.addSubview(title)
            paperwebsTitles.append(title)    //
            
            horizontalNum += 1
            if horizontalNum == 3 {
                horizontalNum = 0
                paperwebsY += 150
                desk.contentSize = CGSize(width: 374,height: desk.contentSize.height + 150);
            }
        }
    }
    
    func addPaperweb(title:String,content:String,index:Int,id:Int) { //将一张新的纸网页放入数据库，应该从外部被调用
        paperwebs = Database().getPaperwebs()
        paperwebs.append(Paperweb(title: title, content: content, index: index, id: id))
        print("第"+String(paperwebs.count)+"张纸网页被置入,它的id是"+String(id))
        Database().setPaperwebs(paperwebs: paperwebs)
    }
    
    func testAddPaperwebs(number:Int) {//测试用方法，可删除
        for i in 1..<number+1 {
            paperwebs.append(Paperweb(title: "paperweb"+String(i), content: "abcdefg", index: 0, id:i))
        }
        Database().setPaperwebs(paperwebs: paperwebs)
    }
    
    func deletePaperwebs(paperwebs:[Paperweb]) { //每次点击edit增加删除按钮
        
        var paperwebsY = 0
        var horizontalNum  = 0
        
        if searchDid == false {
            for i in 0..<paperwebs.count {
                
                let delete = UIButton(frame: CGRect(x: horizontalNum * 110, y: paperwebsY, width: 20, height: 20))
                delete.setImage(UIImage(named: "deleteButton"), for: UIControl.State.normal)
                delete.tag = paperwebs[i].id
                delete.addTarget(self, action: #selector(tapped2), for: .touchUpInside)
                self.desk.addSubview(delete)
                paperwebsButtons.append(delete)
                
                horizontalNum += 1
                if horizontalNum == 3 {
                    horizontalNum = 0
                    paperwebsY += 150
                    desk.contentSize = CGSize(width: 374,height: desk.contentSize.height + 150);
                }
            }
        }else{
            for i in 0..<paperwebsSearch.count{
                
                let delete = UIButton(frame: CGRect(x: horizontalNum * 110, y: paperwebsY, width: 20, height: 20))
                delete.setImage(UIImage(named: "deleteButton"), for: UIControl.State.normal)
                delete.tag = paperwebsSearch[i].id
                delete.addTarget(self, action: #selector(tapped2), for: .touchUpInside)
                self.desk.addSubview(delete)
                paperwebsButtons.append(delete)
                
                horizontalNum += 1
                if horizontalNum == 3 {
                    horizontalNum = 0
                    paperwebsY += 150
                    desk.contentSize = CGSize(width: 374,height: desk.contentSize.height + 150);
                }
                
            }
        }
    }
    
    
    func titleEditPaperwebs(paperwebs:[Paperweb]) { //每次点击title会跳转界面来编辑名字
        
        var paperwebsY = 0
        var horizontalNum  = 0
        
        for i in 0..<paperwebs.count {
            let title = UIButton(frame: CGRect(x: horizontalNum * 110, y: paperwebsY + 120, width: 100, height: 20))
            title.addTarget(self, action: #selector(tapped3), for: .touchUpInside)
            title.tag = paperwebs[i].id
            self.desk.addSubview(title)
            paperwebsButtons.append(title)
            
            horizontalNum += 1
            if horizontalNum == 3 {
                horizontalNum = 0
                paperwebsY += 150
                desk.contentSize = CGSize(width: 374,height: desk.contentSize.height + 150);
            }
        }
    }
    
    
    func removeAll() {
        
        for each in paperwebsButtons{
            each.removeFromSuperview();
        }
        paperwebsButtons = []
        
        for each in paperwebsTitles{
            each.removeFromSuperview();
        }
        paperwebsTitles = []
        
    }
    
    
    @IBAction func edit(_ sender: Any) {
        deletePaperwebs(paperwebs: paperwebs)
        titleEditPaperwebs(paperwebs: paperwebs)
    }
    
    
    @objc func tapped2(sender: UIButton) {
        
        let deleteID = sender.tag
        
       // print(deleteID-1)
        
        Database().deletePaperweb(id: deleteID)
        paperwebs = Database().getPaperwebs()
        
        removeAll()
        setPaperwebs(paperwebs: paperwebs)
        
    }
    
    @objc func tapped3(sender: UIButton) {
        changeTitle(id:sender.tag)
    }
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBAction func search(_ sender: Any) {
        paperwebsSearch = []
        searchDid = true
        for i in 0..<paperwebs.count {
            
            if (paperwebs[i].title == searchBar.text) {
                
                paperwebsSearch.append(paperwebs[i])
                
            }
            removeAll()
            setPaperwebs(paperwebs: paperwebsSearch)
        }
    }
    
    //弹出带有输入框的提示框
    @IBAction func changeTitle(id:Int) {
        //初始化UITextField
        var inputText:UITextField = UITextField();
        let msgAlertCtr = UIAlertController.init(title: "Modify title", message: "Please input your file title", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "confirm", style:.default) { (action:UIAlertAction) ->() in
            self.paperwebs[id-1].title = inputText.text!
            Database().setPaperwebs(paperwebs: self.paperwebs)
            self.removeAll()
            self.setPaperwebs(paperwebs: self.paperwebs)
        }
        
        let cancel = UIAlertAction.init(title: "cancel", style:.cancel) { (action:UIAlertAction) -> ()in
            print("cancel")
        }
        
        msgAlertCtr.addAction(ok)
        msgAlertCtr.addAction(cancel)
        //添加textField输入框
        msgAlertCtr.addTextField { (textField) in
            //设置传入的textField为初始化UITextField
            inputText = textField
        }
        //设置到当前视图
        self.present(msgAlertCtr, animated: true, completion: nil)
    }
    
}

