//
//  ViewController.swift
//  KACheckList
//
//  Created by zhihuazhang on 06/23/2016.
//  Copyright (c) 2016 zhihuazhang. All rights reserved.
//

import UIKit
import KACheckList


class ViewController: UIViewController {

    @IBOutlet weak var testBtn: UIButton!
    
    let data = ["A", "B", "C", "D", "E", "F"]
    var currentData = "B"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateBtnTitle()
    }
    
    func updateBtnTitle() {
        testBtn.setTitle(currentData, forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnTapped(sender: AnyObject) {
        let vc = KACheckList.checkList(data, selectedData: currentData) {[weak self] (selectedData) in
            if let selectedData = selectedData {
                self?.currentData = selectedData
                self?.updateBtnTitle()
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

