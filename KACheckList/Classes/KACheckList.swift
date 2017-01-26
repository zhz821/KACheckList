//
//  KACheckList.swift
//  Pods
//
//  Created by 張志華 on 2016/06/23.
//
//

import UIKit

open class KACheckList: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var dataSource = [String]()
    fileprivate var selectedDatas = [String]()
    
    fileprivate var multipleSelect = true
    
    fileprivate var didSelectedDatas: ((_ selectedDatas: [String]?, _ selectedIndexes: [Int]?) -> Void)?
    
    open var autoBack = false
    
    open class func checkList(_ dataSource: [String]?,
                              selectedDatas: [String]?,
                              done: ((_ selectedDatas: [String]?, _ selectedIndexes: [Int]?) -> Void)?) -> KACheckList {
        let podBundle = Bundle(for: self.classForCoder())
        let bundleURL = podBundle.url(forResource: "KACheckList", withExtension: "bundle")!
        let bundle = Bundle(url: bundleURL)
        let storyboard = UIStoryboard(name: "KACheckList", bundle: bundle)
        let vc = storyboard.instantiateInitialViewController() as! KACheckList
        
        vc.dataSource = dataSource ?? [String]()
        vc.selectedDatas = selectedDatas ?? [String]()
        
        vc.didSelectedDatas = done
        
        return vc
    }
    
    open class func checkList(_ dataSource: [String]?,
                              selectedData: String?,
                              done: ((_ selectedData: String?, _ selectedIndex: Int?) -> Void)?) -> KACheckList {
        let vc = checkList(dataSource, selectedDatas: selectedData != nil ? [selectedData!] : nil) { (selectedDatas, selectedIndexes) in
            done?(selectedDatas?.first, selectedIndexes?.first)
        }
        
        vc.multipleSelect = false
        
        return vc
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelection = multipleSelect
        
        _ = selectedDatas.map {
            if let row = dataSource.index(of: $0) {
                let indexPath = IndexPath(row: row, section: 0)
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        guard let selectedIndexPathes = tableView.indexPathsForSelectedRows, selectedIndexPathes.count > 0 else {
            didSelectedDatas?(nil, nil)
            return
        }
        
        var selectedDatas = [String]()
        var selectedIndexes = [Int]()

        _ = selectedIndexPathes
            .sorted {
                $0 < $1
            }
            .map {
                selectedIndexes.append($0.row)
                selectedDatas.append(dataSource[$0.row])
        }
        
        didSelectedDatas?(selectedDatas, selectedIndexes)
    }
    
}

extension KACheckList: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let data = dataSource[indexPath.row]
        
        cell.textLabel?.text = data

        cell.accessoryType = cell.isSelected ? .checkmark : .none
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        if autoBack {
            let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}
