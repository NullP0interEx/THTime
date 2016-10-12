//
//  JsonParser.swift
//  THTime
//
//  Created by Roman Kobosil on 11.10.16.
//  Copyright © 2016 Roman Kobosil. All rights reserved.
//

import Foundation
import SwiftDate

class JsonParser {
    
    public static func parseSemesterRequest(requestData: String) -> [Semester] {
        var semesterArray: [Semester] = []
        do {
            let data = requestData.data(using: .utf8)!
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            
            
            
            if let dictionary = json as? [String: Any]  {
                if let response = dictionary["response"] as? [String: Any] {
                    if let current = response["current"] as? [String: Any] {
                        var semster = Semester()
                
                        if let semesterID = current["semester"] as? String {
                            semster.id = semesterID
                        }
                        
                        if let name = current["name"] as? String {
                            semster.name = name
                        }
                        
                        if let groupsArray = current["groups"] as? [Any] {
                            for case let group as String in groupsArray {
                                semster.seminargroups.append(group)
                            }
                            
                        }
                        
                       semesterArray.append(semster)
                    }
                    
                }
            }
            
            
        } catch {
            print("error serializing JSON: \(error)")
        }
        return semesterArray
    }
    
    public static func parseTimetableRequest(requestData: String) -> [Lesson] {
        let berlin = Region(tz: TimeZoneName.europeBerlin, cal: CalendarName.gregorian, loc: LocaleName.german)
        var lessons: [Lesson] = []
        
        do {
            let data = requestData.data(using: .utf8)!
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let dictionary = json as? [String: Any]  {
                if let response = dictionary["response"] as? [Any] {
                    for objects in response {
                        if let lessonDictionary = objects as? [String: Any] {
                            var lesson = Lesson()
                            
                            if let id = lessonDictionary["id"] as? String {
                                lesson.id = Int(id)!
                            }
                            
                            if let name = lessonDictionary["name"] as? String {
                                lesson.name = name
                            }
                            
                            if let lecturer = lessonDictionary["lecturer"] as? String {
                                lesson.lecturer = lecturer
                            }
                            
                            if let room = lessonDictionary["room"] as? String {
                                lesson.room = room
                            }
                            
                            if let set = lessonDictionary["set"] as? String {
                                lesson.set = set
                            }
                            
                            if let typeDictionary = lessonDictionary["type"] as? [String: String] {
                                for (key, value) in typeDictionary {
                                    lesson.type[key] = value
                                }
                            }
                            
                            if let start_date = lessonDictionary["start_date"] as? String {
                                lesson.start_date = try DateInRegion(string: start_date, format: .custom("yyyy-MM-dd"), fromRegion: berlin)
                            }
                            
                            if let start_time = lessonDictionary["start_time"] as? String {
                                lesson.start_time = try DateInRegion(string: start_time, format: .custom("HH:mm:ss"), fromRegion: berlin)
                            }
                            
                            if let end_time = lessonDictionary["end_time"] as? String {
                                lesson.end_time = try DateInRegion(string: end_time, format: .custom("HH:mm:ss"), fromRegion: berlin)
                            }
                            
                            if let datesArray = lessonDictionary["dates"] as? [Any] {
                                for case let date as String in datesArray {
                                    let dateTime = try DateInRegion(string: date, format: .custom("yyyy-MM-dd"), fromRegion: berlin)
                                    lesson.dates.append(dateTime)
                                }
                            
                            }
                            
                            
                            lessons.append(lesson)
                        }
                    }
                    
                }
            }

            
        } catch {
            print("error serializing JSON: \(error)")
        }
        return lessons
    }
}
