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
        singleBtn.setTitle(selectedData ?? "Single Selection", for: .normal)
        
        if let selectedDatas = selectedDatas {
            multiBtn.setTitle(selectedDatas.joined(separator: ","), for: .normal)
        } else {
            multiBtn.setTitle("Multiple Selection", for: .normal)
        }

    }

    @IBAction func singleBtnTapped(sender: AnyObject) {
        let vc = KACheckList.checkList(data, selectedData: selectedData) {[weak self] (selectedData, selectedIndex) in
            self?.selectedData = selectedData
            self?.updateBtnTitle()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func multipleBtnTapped(sender: AnyObject) {
        let vc = KACheckList.checkList(data, selectedDatas: selectedDatas) { [weak self](selectedDatas, selectedIndexes) in
            self?.selectedDatas = selectedDatas
            self?.updateBtnTitle()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

