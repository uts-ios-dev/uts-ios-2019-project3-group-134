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
    @IBOutlet weak var searchBar: UISearchBar!
    var paperwebs: [Paperweb] = []
    var paperwebsSearch: [Paperweb] = []
    var paperwebsButtons: [UIButton] = []
    var paperwebsTitles: [UILabel] = []
    var searchDid: Bool = false

    var searchText: [String] = []
    var filterText: [String] = []

    struct display {
        var paperwebsWidth = 100
        var paperwebsHight = 120
        var horizontalSpace = 110
        var titleSpace = 70
        var verticalSpace = 150
        var maxHorizontalNum = 3

        var deleteButtonWidth = 20
        var deleteButtonHight = 20

        var editButtonSpace = 120
        var editButtonWidth = 100
        var editButtonHight = 20

        var deskWidth = 374
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadNewPapaerweb()
        desk.isScrollEnabled = true
        desk.contentSize = CGSize(width: display().deskWidth, height: display().verticalSpace);

        paperwebs = Database().getPaperwebs()
        setPaperwebButtons(paperwebs: paperwebs)
    }

    func loadNewPapaerweb() { //Put all the newly acquired Paperwebs into the database
        let userDefault = UserDefaults(suiteName: userDefaultSuiteName().projectName)
        var i = 0
        var key: String
        while(true) {
            key = "paperweb" + String(i)
            if((userDefault?.object(forKey: key)) != nil) {
                if let dict = userDefault!.value(forKey: key) as? NSDictionary {
                    let title = dict.value(forKey: "title") as! String
                    let content = dict.value(forKey: "content") as! String
                    userDefault!.removeObject(forKey: key)
                    userDefault!.synchronize()
                    addPaperweb(title: title, content: content, index: 0, id: Database().getPaperwebsNum() + 1)
                }
                i = i + 1
            } else {
                break
            }
        }
    }

    @objc func toContentView(sender: UIButton) { //Each Paperwebs is triggered after being clicked, gets their id, and then jumps to the content page.
        self.performSegue(withIdentifier: identifier().showDetailView, sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //Pass the parameters to the new page in this method, here is the paper page id
        if segue.identifier == identifier().showDetailView {
            let controller = segue.destination as! ContentViewController
            controller.paperwebId = (sender as! UIButton).tag
        }
    }

    func setPaperwebButtons(paperwebs: [Paperweb]) { //Place all Paperwebs into the current view and be called when the page is refreshed

        var positionY = 0
        var horizontalNum = 0

        for i in 0..<paperwebs.count {

            let btn = UIButton(frame: CGRect(x: horizontalNum * display().horizontalSpace, y: positionY, width: display().paperwebsWidth, height: display().paperwebsHight))
            btn.setImage(UIImage(named: "paperweb"), for: UIControl.State.normal)
            btn.addTarget(self, action: #selector(toContentView), for: .touchUpInside)
            btn.tag = paperwebs[i].id
            self.desk.addSubview(btn)
            paperwebsButtons.append(btn)

            let title = UILabel(frame: CGRect(x: horizontalNum * display().horizontalSpace, y: positionY + display().titleSpace, width: display().paperwebsWidth, height: display().paperwebsHight))
            title.text = paperwebs[i].title
            self.desk.addSubview(title)
            paperwebsTitles.append(title)

            horizontalNum += 1
            if horizontalNum == display().maxHorizontalNum {
                horizontalNum = 0
                positionY += display().verticalSpace
                desk.contentSize = CGSize(width: CGFloat(display().deskWidth), height: desk.contentSize.height + CGFloat(display().verticalSpace));
            }
        }
    }

    func setDeleteButtons(paperwebs: [Paperweb]) { //Add delete buttons to each Paperweb buttons

        var positionY = 0
        var horizontalNum = 0

        for i in 0..<paperwebs.count {

            let delete = UIButton(frame: CGRect(x: horizontalNum * display().horizontalSpace, y: positionY, width: display().deleteButtonWidth, height: display().deleteButtonHight))
            delete.setImage(UIImage(named: "deleteButton"), for: UIControl.State.normal)
            delete.tag = paperwebs[i].id
            delete.addTarget(self, action: #selector(deletePaperweb), for: .touchUpInside)
            self.desk.addSubview(delete)
            paperwebsButtons.append(delete)

            horizontalNum += 1
            if horizontalNum == display().maxHorizontalNum {
                horizontalNum = 0
                positionY += display().verticalSpace
                desk.contentSize = CGSize(width: CGFloat(display().deskWidth), height: desk.contentSize.height + CGFloat(display().verticalSpace));
            }
        }
    }

    func setEditButtons(paperwebs: [Paperweb]) { //Add edit buttons to each Paperweb buttons

        var positionY = 0
        var horizontalNum = 0

        for i in 0..<paperwebs.count {
            let title = UIButton(frame: CGRect(x: horizontalNum * display().horizontalSpace, y: positionY + display().editButtonSpace, width: display().editButtonWidth, height: display().editButtonHight))
            title.addTarget(self, action: #selector(changeTitle), for: .touchUpInside)
            title.tag = paperwebs[i].id
            self.desk.addSubview(title)
            paperwebsButtons.append(title)

            horizontalNum += 1
            if horizontalNum == display().maxHorizontalNum {
                horizontalNum = 0
                positionY += display().verticalSpace
                desk.contentSize = CGSize(width: CGFloat(display().deskWidth), height: desk.contentSize.height + CGFloat(display().verticalSpace));
            }
        }
    }


    func removeAll() { //remove all Papaerwebs,lables and buttons from the screen

        for each in paperwebsButtons {
            each.removeFromSuperview();
        }
        paperwebsButtons = []

        for each in paperwebsTitles {
            each.removeFromSuperview();
        }
        paperwebsTitles = []

    }

    @IBAction func editMode(_ sender: Any) { //show delete buttons and edit buttons to all current papaerwebs
        if searchDid == true {
            setDeleteButtons(paperwebs: paperwebsSearch)
            setEditButtons(paperwebs: paperwebsSearch)
        } else {
            setDeleteButtons(paperwebs: paperwebs)
            setEditButtons(paperwebs: paperwebs)
        }

    }

    @objc func deletePaperweb(sender: UIButton) { //delete a Paperweb from database and reset the screen
        let deleteID = sender.tag
        Database().deletePaperweb(id: deleteID)
        refresh(sender)
    }

    @objc func changeTitle(sender: UIButton) { //Pop up a prompt box with an input box
        var inputText: UITextField = UITextField();
        let msgAlertCtr = UIAlertController.init(title: "Modify title", message: "Please input your file title", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "confirm", style: .default) { (action: UIAlertAction) -> () in
            self.paperwebs[sender.tag - 1].title = inputText.text!
            Database().setPaperwebs(paperwebs: self.paperwebs)
            self.refresh(sender)
        }

        let cancel = UIAlertAction.init(title: "cancel", style: .cancel) { (action: UIAlertAction) -> ()in
            print("cancel")
        }

        msgAlertCtr.addAction(ok)
        msgAlertCtr.addAction(cancel)
        msgAlertCtr.addTextField { (textField) in
            inputText = textField
        }
        //Set to current view
        self.present(msgAlertCtr, animated: true, completion: nil)
    }

    func addPaperweb(title: String, content: String, index: Int, id: Int) { //Put a new paper page into the database
        paperwebs = Database().getPaperwebs()
        paperwebs.append(Paperweb(title: title, content: content, index: index, id: id))
        Database().setPaperwebs(paperwebs: paperwebs)
    }

    @IBAction func search(_ sender: Any) {
        paperwebsSearch = []
        searchText = []
        searchDid = true

        for i in 0..<paperwebs.count {
            searchText.append(paperwebs[i].title)
            filterText = searchText.filter({ $0.lowercased().contains(searchBar.text!.lowercased()) })
            if searchBar.text == "" {
                paperwebsSearch.append(paperwebs[i])
            } else {
                for j in 0..<filterText.count {
                    if (paperwebs[i].title == filterText[j]) {
                        paperwebsSearch.append(paperwebs[i])
                    }
                }
                removeAll()
                setPaperwebButtons(paperwebs: paperwebsSearch)
            }
        }
    }

    @IBAction func refresh(_ sender: Any) {
        loadNewPapaerweb()
        paperwebs = Database().getPaperwebs()
        removeAll()
        searchDid = false
        setPaperwebButtons(paperwebs: paperwebs)
    }

}

