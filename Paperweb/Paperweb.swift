//
//  Paperweb.swift
//  Papaerweb
//
//  Created by 蓝昭辰 on 2019/5/19.
//  Copyright © 2019 UTS. All rights reserved.
//

import Foundation

class Paperweb {
    var title:String
    var content:String
    var index:Int
    var id:Int

    init(title:String,content:String,index:Int,id:Int) {
        self.title = title
        self.content = content
        self.index = index
        self.id = id
    }
}
