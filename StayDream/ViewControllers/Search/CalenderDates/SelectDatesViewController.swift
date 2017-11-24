//
//  SelectDatesViewController.swift
//  StayDream
//
//  Created by Sharisti on 06/11/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit
import FSCalendar
typealias DateSelectionBlock = (_ startDate: Date, _ endDate: Date) -> Void
class SelectDatesViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {

    // MARK: Outlet
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    var blockToNotifySelectedDates: DateSelectionBlock?
    @IBOutlet weak var calender: FSCalendar!
    var startDate: Date?
    var endDate: Date?
    // MARK: Variables
    let regularFontSubTitle = FontFamily.Tahoma.normal.font(size: 12)
     let regularFontTitle = FontFamily.Tahoma.normal.font(size: 15)

    fileprivate var lunar: Bool = false {
        didSet {
            self.calender.reloadData()
        }
    }

    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return formatter
    }()

//    fileprivate let formatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter
//    }()

    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    // MARK:- Life cycle

    override func viewDidLoad() {

        super.viewDidLoad()
        self.calender.locale = NSLocale(localeIdentifier: AppConstants.localIdentifier) as Locale!
        self.calender.scrollDirection = .vertical
        self.calender.appearance.headerTitleFont =  regularFontTitle
        self.calender.appearance.weekdayFont =  regularFontSubTitle
        self.calender.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
          self.calender.swipeToChooseGesture.isEnabled = true

//        self.calender.select(DateUtility.getDateStr(from: Date()))
        let scopeGesture = UIPanGestureRecognizer(target: self.calender, action: #selector(self.calender.handleScopeGesture(_:)))
        self.calender.addGestureRecognizer(scopeGesture)

        // For UITest
        self.calender.accessibilityIdentifier = "calendar"

    }

    // MARK:- FSCalendarDataSource

//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return self.gregorian.isDateInToday(date) ? "今天" : nil
//    }

    func maximumDate(for calendar: FSCalendar) -> Date {
        let monthsToAdd = 11 // 1 year table we will display
        let newDate = Calendar.current.date(byAdding: .month, value: monthsToAdd, to: Date())
        if let date = DateUtility.getDateStr(from: newDate!) {
            return  date

        }
        return self.formatter.date(from: "2018-11-30")!
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        if let date = DateUtility.getDateStr(from: Date()) {
             return  date

        }
        return self.formatter.date(from: "2017-11-1")!
    }
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }

    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }

    // MARK:- FSCalendarDelegate

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("change page to \(self.formatter.string(from: calendar.currentPage))")
    }

    // MARK:- FSCalendarDelegate

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calender.frame.size.height = bounds.height
        self.view.layoutIfNeeded()
    }

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }

    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.formatter.string(from: date))")
        print("calender.selectedDates:\(calender.selectedDates)")
        self.configureVisibleCells()
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        print("did deselect date \(self.formatter.string(from: date))")
        self.configureVisibleCells()
    }

    // MARK: - Private functions

    private func configureVisibleCells() {
        if calender.selectedDates.count > 0 {
            startDate = calender.selectedDates[0]
            endDate = calender.selectedDates[calender.selectedDates.count - 1]
            print("first date \(calender.selectedDates[0])")
            print("last date \( calender.selectedDates[calender.selectedDates.count - 1])")

        }
        calender.visibleCells().forEach { (cell) in
            let date = calender.date(for: cell)
            let position = calender.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }

    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {

        let diyCell = (cell as! DIYCalendarCell)
        // Custom today circle
        diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        // Configure selection layer
        if position == .current {

            var selectionType = SelectionType.none

            if calender.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if calender.selectedDates.contains(date) {
                    if calender.selectedDates.contains(previousDate) && calender.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    } else if calender.selectedDates.contains(previousDate) && calender.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    } else if calender.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    } else {
                        selectionType = .single
                    }
                }
            } else {
                selectionType = .none
            }
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType

        } else {
            diyCell.circleImageView.isHidden = true
            diyCell.selectionLayer.isHidden = true
        }
    }

    // MARK: Outlet action

    @IBAction func btnCrossTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnOkTapped(_ sender: Any) {
        guard let startingDate = startDate, let endingDate = endDate else {
             self.dismiss(animated: true, completion: nil)
            return
        }
        self.blockToNotifySelectedDates?(startingDate, endingDate)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnClearTapped(_ sender: Any) {
        if calender.selectedDates.count > 0 {
            calender.clearAllDate()
        }
    }
}
