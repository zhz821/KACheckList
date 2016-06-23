//
//  KACheckList.swift
//  Pods
//
//  Created by 張志華 on 2016/06/23.
//
//

import UIKit

public class KACheckList: UIViewController {
    
    private var dataSource = [String]()
    private var selectedDatas = [String]()
    private var selectedIndexes = [Int]()
    
    private var multipleSelect = false
    
    private var didSelectedDatas: ((selectedDatas: [String]?) -> Void)?
    
    public class func checkList(dataSource: [String]?, selectedDatas: [String]?, done: ((selectedDatas: [String]?) -> Void)?) -> KACheckList {
        let podBundle = NSBundle(forClass: self.classForCoder())
        let bundleURL = podBundle.URLForResource("KACheckList", withExtension: "bundle")!
        let bundle = NSBundle(URL: bundleURL)
        let storyboard = UIStoryboard(name: "KACheckList", bundle: bundle)
        let vc = storyboard.instantiateInitialViewController() as! KACheckList
        
        vc.dataSource = dataSource ?? [String]()
        vc.selectedDatas = selectedDatas ?? [String]()
        
        vc.didSelectedDatas = done
        
        return vc
    }
    
    public class func checkList(dataSource: [String]?, selectedData: String?, done: ((selectedData: String?) -> Void)?) -> KACheckList {
        
        let vc = checkList(dataSource, selectedDatas: selectedData != nil ? [selectedData!] : nil) { (selectedDatas) in
            done?(selectedData: selectedDatas?.first)
        }
        
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        updateSelectedIndex()
    }

    private func updateSelectedIndex() {
        for data in selectedDatas {
            let index = dataSource.indexOf(data)
            if let index = index {
                selectedIndexes.append(index)
            }
        }
    }
}

extension KACheckList: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let data = dataSource[indexPath.row]
        
        cell.textLabel?.text = data
        
        if selectedIndexes.contains(indexPath.row) {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if multipleSelect {
            
        } else {
            
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.accessoryType = .Checkmark
            
            let selected = selectedIndexes.first
            if let selected = selected {
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selected, inSection: 0))
                cell?.accessoryType = .None
            }
            
            selectedDatas.removeAll()
            selectedIndexes.removeAll()
            
            selectedDatas.append(dataSource[indexPath.row])
            updateSelectedIndex()
            
            didSelectedDatas?(selectedDatas: selectedDatas)
        }
    }
}