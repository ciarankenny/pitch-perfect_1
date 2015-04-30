//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Kenny, Ciaran on 4/9/15.
//  Copyright (c) 2015 Kenny, Ciaran. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathURL: NSURL, title: String)
    {
        self.filePathUrl = filePathURL;
        self.title = title;
    }
}
