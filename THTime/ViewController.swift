//
//  ViewController.swift
//  THTime
//
//  Created by Roman Kobosil on 11.10.16.
//  Copyright © 2016 Roman Kobosil. All rights reserved.
//

import Cocoa
import SwiftDate

class ViewController: NSViewController, NSTableViewDataSource {
    
    @IBOutlet weak var comboGroup: NSComboBox!
    @IBOutlet weak var tableLessons: NSTableView!
    @IBOutlet weak var daySelector: NSSegmentedControl!
    @IBOutlet weak var weekOfYearText: NSTextField!
    @IBOutlet weak var weekOfYearStepper: NSStepper!
    @IBOutlet weak var semesterText: NSTextField!
    
    let http = Requests()
    let berlin = Region(tz: TimeZoneName.europeBerlin, cal: CalendarName.gregorian, loc: LocaleName.german)
    var weekOfYear = 0
    var semesterId = "ws"
    var lessons: [Int : [Lesson]] = [
        0:[],
        1:[],
        2:[],
        3:[],
        4:[]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = DateInRegion()
        weekOfYear = date.weekOfYear
        weekOfYearStepper.integerValue = date.weekOfYear
        weekOfYearText.stringValue = String(weekOfYear)
        let weekdayInt = (date.weekday - 2)
        if(weekdayInt <= 4){
            daySelector.integerValue = weekdayInt
        }
        
        if let sem_id = UserDefaults.standard.string(forKey: "sem_id"){
            semesterId = sem_id
        }
        
        if let sem_group = UserDefaults.standard.string(forKey: "sem_group"){
            comboGroup.stringValue = sem_group
        }
        
        reloadData()
        
        http.getGroups(callback: {
            (semester: [Semester]) -> Void in
            
            DispatchQueue.main.sync {
                if let currentSemester = semester.first {
                    self.semesterText.stringValue = currentSemester.name
                    self.semesterId = currentSemester.id
                    for group in currentSemester.seminargroups {
                        self.comboGroup.addItem(withObjectValue: group)
                    }
                    UserDefaults.standard.set(self.semesterId, forKey: "sem_id")
                    UserDefaults.standard.set(self.comboGroup.stringValue, forKey: "sem_group")
                }
            }
            
        })

    }
    
    func reloadData(){
        self.lessons = [
            0:[],
            1:[],
            2:[],
            3:[],
            4:[]]
        self.tableLessons.reloadData()
        http.getTimeTable(semester: semesterId, seminargroups: comboGroup.stringValue, callback: {
            (lessonData: [Lesson]) -> Void in
            
            DispatchQueue.main.sync {
                
                for lesson in lessonData {
                    for datesOfLesson in lesson.dates {
                        if(datesOfLesson.weekOfYear == self.weekOfYear){
                            self.lessons[lesson.start_date.weekday - 2]?.append(lesson)
                        }
                    }
                }
                self.tableLessons.reloadData()
            }
            
        })
    }
    
    @IBAction func onGroupChange(_ sender: AnyObject) {
        UserDefaults.standard.set(comboGroup.stringValue, forKey: "sem_group")
        reloadData()
    }
    
    @IBAction func onWeekOfYearStep(_ sender: AnyObject) {
        weekOfYear = weekOfYearStepper.integerValue
        weekOfYearText.stringValue = String(weekOfYear)
        reloadData()
    }
    @IBAction func onDayChange(_ sender: AnyObject) {
        reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return lessons[daySelector.selectedSegment]!.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        do {
            if tableColumn?.identifier == "time" {
                return lessons[daySelector.selectedSegment]![row].start_time.string(format: .custom("HH:mm:ss")) + "\n" + lessons[daySelector.selectedSegment]![row].end_time.string(format: .custom("HH:mm:ss"))
                
            }
            
            if tableColumn?.identifier == "name" {
                
                return lessons[daySelector.selectedSegment]![row].name + "\n" + lessons[daySelector.selectedSegment]![row].lecturer
                
            }
            
            if tableColumn?.identifier == "room" {
                
                return lessons[daySelector.selectedSegment]![row].room + "\n" + lessons[daySelector.selectedSegment]![row].type["de_DE"]!
                
            }
            
            if tableColumn?.identifier == "set" {
                
                return lessons[daySelector.selectedSegment]![row].set
                
            }
        } catch {
            return "Error"
        }
        return "nill"
    }
    
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}

