//
//  Lesson.swift
//  THTime
//
//  Created by Roman Kobosil on 11.10.16.
//  Copyright © 2016 Roman Kobosil. All rights reserved.
//

import Foundation
import SwiftDate

struct Lesson {
    var id = 0;
    var dates: [DateInRegion] = []
    var start_time =  DateInRegion()
    var end_time = DateInRegion()
    var start_date = DateInRegion()
    var name = ""
    var lecturer = ""
    var type: [String : String] = [:]
    var room = ""
    var set = ""
    
}
