//
//  EmoticonAttachment.swift
//  KeyBoardView
//
//  Created by Kevin on 2019/2/14.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class EmoticonAttachment: NSTextAttachment {

    var emoticon:Emoticon
    
    init(emoticon:Emoticon) {
        self.emoticon = emoticon
        super.init(data: nil, ofType: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
