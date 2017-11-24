//
//  BookingDetailViewController.swift
//  StayDream
//
//  Created by Sharisti on 24/11/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit

class BookingDetailViewController: UIViewController {

    @IBOutlet weak var totalPayment: UILabel!
    @IBOutlet weak var gstFee: UILabel!
    @IBOutlet weak var hstFee: UILabel!
    @IBOutlet weak var cleaningFees: UILabel!
    @IBOutlet weak var costNights: UILabel!
    @IBOutlet weak var nightsCount: UILabel!
    @IBOutlet weak var lblCheckOutTime: UILabel!
    @IBOutlet weak var lblCheckInTime: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblPropertyDesc: UILabel!
    @IBOutlet weak var lblPropertyName: UILabel!
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
