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
    private var selected = [Int: String]()
    
    private var multipleSelect = true
    
    private var didSelectedDatas: ((selectedDatas: [String]?) -> Void)?
    
    public var autoBack = false
    
    public class func checkList(dataSource: [String]?, selectedDatas: [String]?, done: ((selectedDatas: [String]?) -> Void)?) -> KACheckList {
        let podBundle = NSBundle(forClass: self.classForCoder())
        let bundleURL = podBundle.URLForResource("KACheckList", withExtension: "bundle")!
        let bundle = NSBundle(URL: bundleURL)
        let storyboard = UIStoryboard(name: "KACheckList", bundle: bundle)
        let vc = storyboard.instantiateInitialViewController() as! KACheckList
        
        vc.dataSource = dataSource ?? [String]()
        
        vc.didSelectedDatas = done
        
        if let selectedDatas = selectedDatas {
            for data in selectedDatas {
                let index = vc.dataSource.indexOf(data)
                if let index = index {
                    vc.selected[index] = data
                }
            }
        }
        
        return vc
    }
    
    public class func checkList(dataSource: [String]?, selectedData: String?, done: ((selectedData: String?) -> Void)?) -> KACheckList {
        
        let vc = checkList(dataSource, selectedDatas: selectedData != nil ? [selectedData!] : nil) { (selectedDatas) in
            done?(selectedData: selectedDatas?.first)
        }
        
        vc.autoBack = true
        vc.multipleSelect = false
        
        return vc
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let sorted = selected.sort {
            $0.0 < $1.0
        }
        
        let selectedDatas = sorted.map {$0.1}
        
        didSelectedDatas?(selectedDatas: selectedDatas)
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
        
        if selected[indexPath.row] != nil {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if multipleSelect {
            if selected[indexPath.row] != nil {
                cell?.accessoryType = .None
                selected.removeValueForKey(indexPath.row)
            } else {
                cell?.accessoryType = .Checkmark
                selected[indexPath.row] = dataSource[indexPath.row]
            }
        } else {
            if let selectedIndex = selected.first?.0 {
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedIndex, inSection: 0))
                cell?.accessoryType = .None
                
                selected.removeAll()
            }
            
            cell?.accessoryType = .Checkmark
            selected[indexPath.row] = dataSource[indexPath.row]
        }
        
        if autoBack {
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
            
            dispatch_after(delayTime, dispatch_get_main_queue(), {
                self.navigationController?.popViewControllerAnimated(true)
            })
        }
    }
}