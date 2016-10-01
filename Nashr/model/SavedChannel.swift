//
//  SavedChannel.swift
//  Nashr
//
//  Created by Amit Kulkarni on 01/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import Foundation
import RealmSwift

class SavedChannel: Object {
    dynamic var channelId:Int = 0
}

class SavedCategory : Object {
    
    dynamic var categoryId:Int = 0
    var channels = List<SavedChannel>()
    
}