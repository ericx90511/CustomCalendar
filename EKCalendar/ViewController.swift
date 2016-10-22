//
//  ViewController.swift
//  EKCalendar
//
//  Created by Eric Kang on 3/21/15.
//  Copyright (c) 2015 Eric Kang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var daysArray:NSMutableArray?
    var datesTuple:(firstDay:NSDate, lastDay:NSDate)?
    let flag: NSCalendarUnit = NSCalendarUnit(UInt.max)
    let calendar:NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    var calendarView: UIView?
    var calendarTitle: UIView?
    var calendarTitleLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        /* set as previous month for "updateDateComp:" */
        var date:NSDate = NSDate()
        var datComp:NSDateComponents = calendar.components(flag, fromDate: date)
        var defualtDate:NSDate! = calendar.dateFromComponents(datComp)
        var setPrevMonth:NSDateComponents = NSDateComponents()
        setPrevMonth.setValue(-1, forComponent: NSCalendarUnit.CalendarUnitMonth)
        var firstDay:NSDate! = calendar.dateByAddingComponents(setPrevMonth, toDate: date, options: NSCalendarOptions(0))
        
        calendarInit()
        datesTuple = updateDateComp(firstDay)
        makeCalendar(datesTuple!.firstDay, lastDay: datesTuple!.lastDay)
        
    }
    func updateDateComp(date:NSDate) ->(firstDay:NSDate, lastDay:NSDate){
        
        /* set the first day for next month */
        var dateComp:NSDateComponents = calendar.components(flag, fromDate: date)
        dateComp.day = 1
        var defaultDate:NSDate! = calendar.dateFromComponents(dateComp)
        
        /* go to next month */
        var setNextMonth:NSDateComponents = NSDateComponents()
        setNextMonth.setValue(1, forComponent: NSCalendarUnit.CalendarUnitMonth)
        
        /* obtain the NSDate for first day */
        var firstDay:NSDate! = calendar.dateByAddingComponents(setNextMonth, toDate: defaultDate, options: NSCalendarOptions(0))
        
        /* obtain the num of days and weeks in the month */
        let daysOfMonth: Int = (calendar.rangeOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit: NSCalendarUnit.CalendarUnitMonth, forDate: firstDay)).length
        let weeksOfMonth = (calendar.rangeOfUnit(NSCalendarUnit.CalendarUnitWeekOfMonth, inUnit: NSCalendarUnit.CalendarUnitMonth, forDate: firstDay)).length
        
        /* set the last day for next month */
        var lastDayComp:NSDateComponents = calendar.components(flag, fromDate: date)
        lastDayComp.day = daysOfMonth
        
        var lddefaultDate:NSDate! = calendar.dateFromComponents(lastDayComp)
        
        /* go to next month */
        var ssetNextMonth:NSDateComponents = NSDateComponents()
        ssetNextMonth.setValue(1, forComponent: NSCalendarUnit.CalendarUnitMonth)
        
        /* obtain the NSDate for first day */
        var lastDay:NSDate! = calendar.dateByAddingComponents(setNextMonth, toDate: lddefaultDate, options: NSCalendarOptions(0))
        
        
        var firstDateComp:NSDateComponents = calendar.components(flag, fromDate: firstDay)
//        NSLog("%i %i %i %i %i %i %i", firstDateComp.day, firstDateComp.month, firstDateComp.year, weeksOfMonth, daysOfMonth, firstDateComp.day, firstDateComp.weekday)
        
        return (firstDay, lastDay)
    }
    
    func updatePrevMonth(date:NSDate) ->(firstDay:NSDate, lastDay:NSDate){
        
        /* set the first day for next month */
        var dateComp:NSDateComponents = calendar.components(flag, fromDate: date)
        dateComp.day = 1
        var defaultDate:NSDate! = calendar.dateFromComponents(dateComp)
        
        /* go to next month */
        var setNextMonth:NSDateComponents = NSDateComponents()
        setNextMonth.setValue(-1, forComponent: NSCalendarUnit.CalendarUnitMonth)
        
        /* obtain the NSDate for first day */
        var firstDay:NSDate! = calendar.dateByAddingComponents(setNextMonth, toDate: defaultDate, options: NSCalendarOptions(0))
        
        /* obtain the num of days and weeks in the month */
        let daysOfMonth: Int = (calendar.rangeOfUnit(NSCalendarUnit.CalendarUnitMonth, inUnit: NSCalendarUnit.CalendarUnitMonth, forDate: firstDay)).length
        let weeksOfMonth = (calendar.rangeOfUnit(NSCalendarUnit.CalendarUnitMonth, inUnit: NSCalendarUnit.CalendarUnitMonth, forDate: firstDay)).length
        
        /* set the last day for next month */
        var lastDayComp:NSDateComponents = calendar.components(flag, fromDate: date)
        lastDayComp.day = daysOfMonth
        
        var lddefaultDate:NSDate! = calendar.dateFromComponents(lastDayComp)
        
        /* obtain the NSDate for first day */
        var lastDay:NSDate! = calendar.dateByAddingComponents(setNextMonth, toDate: lddefaultDate, options: NSCalendarOptions(0))
        
        
        var firstDateComp:NSDateComponents = calendar.components(flag, fromDate: firstDay)
//        NSLog("prev %i %i %i %i %i %i %i", firstDateComp.day, firstDateComp.month, firstDateComp.year, weeksOfMonth, daysOfMonth, firstDateComp.day, firstDateComp.weekday)
        
        return (firstDay, lastDay)
    }
    
    
    func nextMonth(sender:UIButton!){
        var subviews = calendarView!.subviews as! [UIView]
        for view in subviews {
            if let button = view as? UIButton {
                button.removeFromSuperview()
            }
        }
        datesTuple! = updateDateComp(datesTuple!.firstDay)
        makeCalendar(datesTuple!.firstDay, lastDay:datesTuple!.lastDay)
        
    }
    
    func prevMonth(sender:UIButton!){
        var subviews = calendarView!.subviews as! [UIView]
        for view in subviews {
            if let button = view as? UIButton {
                button.removeFromSuperview()
            }
        }
        datesTuple! = updatePrevMonth(datesTuple!.firstDay)
        makeCalendar(datesTuple!.firstDay, lastDay:datesTuple!.lastDay)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calendarInit(){
        
        /* initialize variable for container */
        let mainview: UIView = self.view
        let screenWidth:CGFloat = UIScreen.mainScreen().bounds.width
        let screenHeight: CGFloat = UIScreen.mainScreen().bounds.height
        var calendarContainer: UIView = UIView(frame: CGRectMake(0, 0, screenWidth * 0.8, screenHeight * 0.8))
        
        
        calendarContainer.layer.borderWidth = 1;
//        calendarContainer.layer.borderColor = UIColor.blackColor().CGColor
        
        /* make a new CGPoint for calendarContainer */
        let customMainViewCGPoint: CGPoint = CGPointMake(mainview.center.x, mainview.center.y)
        
        calendarContainer.center = mainview.convertPoint(customMainViewCGPoint, fromView: mainview.superview)
        calendarContainer.backgroundColor = UIColorFromRGB(0xFFFFFF)
        mainview.addSubview(calendarContainer)
        
        let calendarContainerX = calendarContainer.bounds.origin.x
        let calendarContainerY = calendarContainer.bounds.origin.y
        
        /* calendar title */
        let calendarTitleCGPointX = calendarContainerX
        let calendarTitleCGPointY = calendarContainerY // assign 20 % of calendarContainer
        let calendarTitleHeight = calendarContainer.bounds.height * 0.1
        
        calendarTitle = UIView(frame:CGRectMake(calendarTitleCGPointX, calendarTitleCGPointY,calendarContainer.bounds.width , calendarTitleHeight))
        calendarTitle!.layer.borderWidth = 1
        calendarContainer.addSubview(calendarTitle!)
        
        /* calendar title label */
        calendarTitleLabel = UILabel(frame: CGRectInset(calendarTitle!.bounds, 3, 0))
        calendarTitleLabel!.textAlignment = NSTextAlignment.Center
        calendarTitle!.addSubview(calendarTitleLabel!)
        
        /* making calendar header for weekdays */
        var monSunDays: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let containerWidthBy7 = calendarContainer.bounds.width / 7
        var cellWidth: CGFloat = 0
        
        let calHeaderHeight = calendarContainer.bounds.height / 8
        for var index = 0 ; index < 7 ; index++ {
            var calendarHeader: UIView = UIView(frame: CGRectMake(cellWidth, calendarTitleHeight, containerWidthBy7, calHeaderHeight ))
            calendarHeader.layer.borderWidth = 1
            calendarContainer.addSubview(calendarHeader)
            cellWidth += containerWidthBy7
            var headerLabel: UILabel = UILabel(frame: CGRectInset(calendarHeader.bounds, 3, 0))
            headerLabel.text = monSunDays[index]
            headerLabel.textAlignment = NSTextAlignment.Center
            calendarHeader.addSubview(headerLabel)
            
        }
        
        /* next month button */
        var nextMonthButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        nextMonthButton.frame = CGRectMake(calendarContainer.frame.origin.x + calendarContainer.bounds.width, calendarContainer.frame.origin.y , (mainview.bounds.width - screenWidth * 0.8) / 2, calendarContainer.bounds.height / 2)
        nextMonthButton.layer.borderWidth = 1
        mainview.addSubview(nextMonthButton)
        
        nextMonthButton.addTarget(self, action: "nextMonth:", forControlEvents: UIControlEvents.TouchUpInside)
        var nextLabel:UILabel = UILabel(frame: CGRectInset(nextMonthButton.bounds, 3, 0))
        nextLabel.text = ">"
        nextLabel.textAlignment = NSTextAlignment.Center
        nextLabel.textColor = UIColor.blackColor()
        nextMonthButton.addSubview(nextLabel)
        
        /* previous month button */
        var previousMonthButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        previousMonthButton.frame = CGRectMake(calendarContainer.frame.origin.x + calendarContainer.bounds.width, calendarContainer.frame.origin.y + calendarContainer.bounds.height / 2, (mainview.bounds.width - screenWidth * 0.8) / 2, calendarContainer.bounds.height / 2)
        mainview.addSubview(previousMonthButton)
        
        previousMonthButton.addTarget(self, action: "prevMonth:", forControlEvents: UIControlEvents.TouchUpInside)
        var prevLabel:UILabel = UILabel(frame: CGRectInset(previousMonthButton.bounds, 3, 0))
        prevLabel.text = "<"
        prevLabel.textAlignment = NSTextAlignment.Center
        prevLabel.textColor = UIColor.blackColor()
        previousMonthButton.addSubview(prevLabel)
        
        
        /* calendarView container */
        calendarView = UIView(frame: CGRectMake(calendarContainerX, calendarTitleHeight + calHeaderHeight, calendarContainer.bounds.width, calendarContainer.bounds.height - 2 * calHeaderHeight))
        calendarView!.layer.borderWidth = 1
        calendarContainer.addSubview(calendarView!)
        
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func findCorrespondMonth(month:Int)->String{
        var stringMonth:String = ""
        switch month{
            case 1:
                stringMonth = "Jan"
            case 2:
                stringMonth = "Feb"
            case 3:
                stringMonth = "Mar"
            case 4:
                stringMonth = "Apr"
            case 5:
                stringMonth = "May"
            case 6:
                stringMonth = "June"
            case 7:
                stringMonth = "July"
            case 8:
                stringMonth = "Aug"
            case 9:
                stringMonth = "Sept"
            case 10:
                stringMonth = "Oct"
            case 11:
                stringMonth = "Nov"
            case 12:
                stringMonth = "Dec"
            default:
                stringMonth = "UNDEFINED"
        }
        return stringMonth
    }
    
    
    func makeCalendar(firstDay:NSDate, lastDay:NSDate){
        
        var dateComp:NSDateComponents = calendar.components(flag, fromDate: firstDay)
        
        /* set calendar title month */
        calendarTitleLabel!.text = findCorrespondMonth(dateComp.month)
        
        let daysOfMonth: Int = (calendar.rangeOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit: NSCalendarUnit.CalendarUnitMonth, forDate: firstDay)).length
        /* width and height for cell in calView */
        let calViewCellWidth = calendarView!.bounds.width / 7
        let calViewCellHeight = calendarView!.bounds.height / 7
        
        var currentWeekDay = dateComp.weekday
        
        let weeksOfMonth = (calendar.rangeOfUnit(NSCalendarUnit.CalendarUnitMonth, inUnit: NSCalendarUnit.CalendarUnitMonth, forDate: firstDay)).length
        var numOfCellRow = currentWeekDay
        var currentRow = calendarView!.bounds.origin.y
        
        /* weekday is sunday then first column otherwise calcualte the width */
        var currentColumn = currentWeekDay == 1 ? calendarView!.bounds.origin.x : (CGFloat)(currentWeekDay - 1) * calViewCellWidth + calendarView!.bounds.origin.x
        
        
        for var day = dateComp.day ; day <= daysOfMonth ; day++ {
            /* cell number exceed 7 then go to next row */
            if numOfCellRow > 7 {
                numOfCellRow = 1;
                currentRow += calViewCellHeight
                currentColumn = calendarView!.bounds.origin.x
            }
            
            var cellButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            cellButton.frame = CGRectMake(currentColumn, currentRow, calViewCellWidth, calViewCellHeight)
//            cellButton.layer.borderWidth = 1
            calendarView!.addSubview(cellButton)
            
            let cellButtonLabel: UILabel = UILabel(frame: CGRectInset(cellButton.bounds, 3, 0))
            cellButtonLabel.textAlignment = NSTextAlignment.Center
            cellButtonLabel.text = String(day)
            cellButton.addSubview(cellButtonLabel)
            
            numOfCellRow++;
            currentColumn += calViewCellWidth
            
        }
        
    }
    
}