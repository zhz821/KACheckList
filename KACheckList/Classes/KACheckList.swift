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
    
    private var dataSource = [String]()
    private var selectedValues = [String]()
    
    private var isMultipleSelect = true
    
    private var didSelectedValue: ((_ selectedValues: [String]?, _ selectedIndexes: [Int]?) -> Void)?
    
    open var autoBack = false
    
    open class func checkList(dataSource: [String]?,
                              selectedValues: [String]?,
                              done: ((_ selectedValues: [String]?, _ selectedIndexes: [Int]?) -> Void)?) -> KACheckList {
        let podBundle = Bundle(for: self.classForCoder())
        let bundleURL = podBundle.url(forResource: "KACheckList", withExtension: "bundle")!
        let bundle = Bundle(url: bundleURL)
        
        let storyboard = UIStoryboard(name: "KACheckList", bundle: bundle)
        let vc = storyboard.instantiateInitialViewController() as! KACheckList
        
        vc.dataSource = dataSource ?? [String]()
        vc.selectedValues = selectedValues ?? [String]()
        
        vc.didSelectedValue = done
        
        return vc
    }
    
    open class func checkList(dataSource: [String]?,
                              selectedValue: String?,
                              done: ((_ selectedValue: String?, _ selectedIndex: Int?) -> Void)?) -> KACheckList {
        let vc = checkList(dataSource: dataSource, selectedValues: selectedValue != nil ? [selectedValue!] : nil) { (selectedValue, selectedIndexes) in
            done?(selectedValue?.first, selectedIndexes?.first)
        }
        
        vc.isMultipleSelect = false
        
        return vc
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelection = isMultipleSelect
        
        selectedValues.forEach {
            if let row = dataSource.index(of: $0) {
                let indexPath = IndexPath(row: row, section: 0)
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let selectedIndexPathes = tableView.indexPathsForSelectedRows, selectedIndexPathes.count > 0 else {
            didSelectedValue?(nil, nil)
            return
        }
        
        var selectedValues = [String]()
        var selectedIndexes = [Int]()
        
        selectedIndexPathes
            .sorted {
                $0 < $1
            }
            .forEach {
                selectedIndexes.append($0.row)
                selectedValues.append(dataSource[$0.row])
        }
        
        didSelectedValue?(selectedValues, selectedIndexes)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}
