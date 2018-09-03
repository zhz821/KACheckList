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
    var selectedValue: String?
    var selectedValues: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateBtnTitle() {
        singleBtn.setTitle(selectedValue ?? "Single Selection", for: .normal)
        
        if let selectedDatas = selectedValues {
            multiBtn.setTitle(selectedDatas.joined(separator: ","), for: .normal)
        } else {
            multiBtn.setTitle("Multiple Selection", for: .normal)
        }
        
    }
    
    @IBAction func singleBtnTapped(sender: AnyObject) {
        let vc = KACheckList.checkList(dataSource: data, selectedValue: selectedValue) {[weak self] (selectedValue, selectedIndex) in
            self?.selectedValue = selectedValue
            self?.updateBtnTitle()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func multipleBtnTapped(sender: AnyObject) {
        let vc = KACheckList.checkList(dataSource: data, selectedValues: selectedValues) { [weak self](selectedValues, selectedIndexes) in
            self?.selectedValues = selectedValues
            self?.updateBtnTitle()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


