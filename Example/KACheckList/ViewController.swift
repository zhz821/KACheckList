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

    @IBOutlet weak var singleBtn: UIButton!
    @IBOutlet weak var multiBtn: UIButton!
    
    let data = ["A", "B", "C", "D", "E", "F"]
    var selectedData: String?
    var selectedDatas: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateBtnTitle() {
        singleBtn.setTitle(selectedData, forState: .Normal)
        
        if let selectedDatas = selectedDatas {
            multiBtn.setTitle(selectedDatas.joinWithSeparator(","), forState: .Normal)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func singleBtnTapped(sender: AnyObject) {
        let vc = KACheckList.checkList(data, selectedData: selectedData) {[weak self] (selectedData) in
            if let selectedData = selectedData {
                self?.selectedData = selectedData
                self?.updateBtnTitle()
            }
        }
        
        showViewController(vc, sender: nil)
    }
    
    @IBAction func multipleBtnTapped(sender: AnyObject) {
        let vc = KACheckList.checkList(data, selectedDatas: selectedDatas) { [weak self](selectedDatas) in
            if let selectedDatas = selectedDatas {
                self?.selectedDatas = selectedDatas
                self?.updateBtnTitle()
            }
        }
        showViewController(vc, sender: nil)
    }
    
}

