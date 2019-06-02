//
//  PaperwebButton.swift
//  Paperweb
//
//  Created by 蓝昭辰 on 2019/6/2.
//  Copyright © 2019 UTS. All rights reserved.
//

import Foundation
import UIKit

class PaperwebButton:UIButton {
    init(x:Int,y:Int) {
        super.init(frame: CGRect(x:x, y: y, width: 100, height: 120))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
