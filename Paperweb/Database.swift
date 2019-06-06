//
//  Database.swift
//  Papaerweb
//
//  Created by 蓝昭辰 on 2019/5/19.
//  Copyright © 2019 UTS. All rights reserved.
//

import Foundation

class Database {
    func setPaperwebs(paperwebs: [Paperweb]) {
        var titleList: [String] = []
        var contentList: [String] = []
        var indexList: [Int] = []
        for i in 0..<paperwebs.count {
            titleList.append(paperwebs[i].title)
            contentList.append(paperwebs[i].content)
            indexList.append(paperwebs[i].index)
        }
        UserDefaults.standard.set(titleList, forKey: userDefaultKeys().titleList)
        UserDefaults.standard.set(contentList, forKey: userDefaultKeys().contentList)
        UserDefaults.standard.set(indexList, forKey: userDefaultKeys().indexList)
        UserDefaults.standard.set(true, forKey: userDefaultKeys().paperwebs)
    }

    func getPaperwebs() -> [Paperweb] {
        var paperwebs: [Paperweb] = []
        if UserDefaults.standard.value(forKey: userDefaultKeys().paperwebs) != nil {
            var titleList = UserDefaults.standard.value(forKey: userDefaultKeys().titleList) as! [String]
            var contentList = UserDefaults.standard.value(forKey: userDefaultKeys().contentList) as! [String]
            var indexList = UserDefaults.standard.value(forKey: userDefaultKeys().indexList) as! [Int]
            if titleList.count == contentList.count {
                for i in 1..<contentList.count + 1 {
                    paperwebs.append(Paperweb(title: titleList[i - 1], content: contentList[i - 1], index: indexList[i - 1], id: i))
                }
            }
        }
        return paperwebs
    }

    func getContent(id: Int) -> String {
        if UserDefaults.standard.value(forKey: userDefaultKeys().paperwebs) != nil {
            return (UserDefaults.standard.value(forKey: userDefaultKeys().contentList) as! [String]) [id - 1]
        } else {
            return ""
        }
    }

    func getIndex(id: Int) -> Int {
        if UserDefaults.standard.value(forKey: userDefaultKeys().paperwebs) != nil {
            return (UserDefaults.standard.value(forKey: userDefaultKeys().indexList) as! [Int]) [id - 1]
        } else {
            return 0
        }
    }

    func setIndex(id: Int, index: Int) {
        if UserDefaults.standard.value(forKey: userDefaultKeys().paperwebs) != nil {
            var Paperwebs: [Paperweb] = self.getPaperwebs()
            Paperwebs[id - 1].index = index
            self.setPaperwebs(paperwebs: Paperwebs)
        }
    }

    func getPaperwebsNum() -> Int {
        if UserDefaults.standard.value(forKey: userDefaultKeys().paperwebs) != nil {
            return (UserDefaults.standard.value(forKey: userDefaultKeys().contentList) as! [String]).count
        }
        return 0
    }

    func deletePaperweb(id: Int) {
        if UserDefaults.standard.value(forKey: userDefaultKeys().paperwebs) != nil {
            var Paperwebs: [Paperweb] = self.getPaperwebs()
            Paperwebs.remove(at: id - 1)
            self.setPaperwebs(paperwebs: Paperwebs)
        }
    }
}
