//
//  KACheckList.swift
//  Pods
//
//  Created by 張志華 on 2016/06/23.
//
//

import UIKit

open class KACheckList: UIViewController {
    
    fileprivate var dataSource = [String]()
    fileprivate var selected = [Int: String]()
    
    fileprivate var multipleSelect = true
    
    fileprivate var didSelectedDatas: ((_ selectedDatas: [String]?) -> Void)?
    
    open var autoBack = false
    
    open class func checkList(_ dataSource: [String]?, selectedDatas: [String]?, done: ((_ selectedDatas: [String]?) -> Void)?) -> KACheckList {
        let podBundle = Bundle(for: self.classForCoder())
        let bundleURL = podBundle.url(forResource: "KACheckList", withExtension: "bundle")!
        let bundle = Bundle(url: bundleURL)
        let storyboard = UIStoryboard(name: "KACheckList", bundle: bundle)
        let vc = storyboard.instantiateInitialViewController() as! KACheckList
        
        vc.dataSource = dataSource ?? [String]()
        
        vc.didSelectedDatas = done
        
        if let selectedDatas = selectedDatas {
            for data in selectedDatas {
                let index = vc.dataSource.index(of: data)
                if let index = index {
                    vc.selected[index] = data
                }
            }
        }
        
        return vc
    }
    
    open class func checkList(_ dataSource: [String]?, selectedData: String?, done: ((_ selectedData: String?) -> Void)?) -> KACheckList {
        
        let vc = checkList(dataSource, selectedDatas: selectedData != nil ? [selectedData!] : nil) { (selectedDatas) in
            done?(selectedDatas?.first)
        }
        
        vc.autoBack = true
        vc.multipleSelect = false
        
        return vc
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let sorted = selected.sorted {
            $0.0 < $1.0
        }
        
        let selectedDatas = sorted.map {$0.1}
        
        didSelectedDatas?(selectedDatas)
    }
    
}

extension KACheckList: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let data = dataSource[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = data
        
        if selected[(indexPath as NSIndexPath).row] != nil {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if multipleSelect {
            if selected[(indexPath as NSIndexPath).row] != nil {
                cell?.accessoryType = .none
                selected.removeValue(forKey: (indexPath as NSIndexPath).row)
            } else {
                cell?.accessoryType = .checkmark
                selected[(indexPath as NSIndexPath).row] = dataSource[(indexPath as NSIndexPath).row]
            }
        } else {
            if let selectedIndex = selected.first?.0 {
                let cell = tableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0))
                cell?.accessoryType = .none
                
                selected.removeAll()
            }
            
            cell?.accessoryType = .checkmark
            selected[(indexPath as NSIndexPath).row] = dataSource[(indexPath as NSIndexPath).row]
        }
        
        if autoBack {
            let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
}
