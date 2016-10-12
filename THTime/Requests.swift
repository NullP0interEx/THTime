//
//  Requests.swift
//  THTime
//
//  Created by Roman Kobosil on 11.10.16.
//  Copyright © 2016 Roman Kobosil. All rights reserved.
//

import Foundation

class Requests {
    
    let TH_TM_SERVER = "https://server01.tm.th-wildau.de/"

    public func getTimeTable(semester: String, seminargroups: String, callback: @escaping (_ lessonData: [Lesson]) -> Void) {
    
        let url = TH_TM_SERVER + "services.php?using_version=1.4&service=Timetable&action=student&type=all&as_array=true&semester=" + semester + "&seminargroups%5B%5D=" + seminargroups
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            if let data = data,
                let html = String(data: data, encoding: String.Encoding.utf8) {
                let lessons: [Lesson] = JsonParser.parseTimetableRequest(requestData: html)
                callback(lessons)
            }
        }
        task.resume()
    }
    
    public func getGroups(callback: @escaping (_ semester: [Semester]) -> Void) {
        
        let url = TH_TM_SERVER + "/services.php?using_version=1.4&service=Timetable&action=seminargroups"
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            if let data = data,
                let html = String(data: data, encoding: String.Encoding.utf8) {
                let semester: [Semester] = JsonParser.parseSemesterRequest(requestData: html)
                callback(semester)
            }
        }
        task.resume()
    }
}
