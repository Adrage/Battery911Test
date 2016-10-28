//
//  testResultListTableViewController.swift
//  Battery911Test
//
//  Created by Adrian C. Johnson on 10/27/16.
//  Copyright © 2016 CrossVIsion Development Studios. All rights reserved.
//

import Foundation

class TestResultListTableViewController: UITableViewController {
    
    var fetchedResultsController: NSFetchedResultsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController = TestResult.MR_fetchAllSortedBy("timeStamp", ascending: false, withPredicate: nil, groupBy: nil, delegate: self)
        fetchedResultsController?.delegate = self
        
        tableView.registerNib(UINib(nibName: TestResultListTableViewCell.cellName(), bundle: nil), forCellReuseIdentifier: TestResultListTableViewCell.cellIdentifier())
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Edit", comment: ""), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TestResultListTableViewController.editTableView(_:)))
        
        self.title = "Test Results"
    }
    
    // MARK: - UITableViewController Datasource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController!.sections![section].numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TestResultListTableViewCell.cellIdentifier(), forIndexPath: indexPath) as! TestResultListTableViewCell
        if let testResult = fetchedResultsController?.objectAtIndexPath(indexPath) as? TestResult {
            cell.configureForTestResult(testResult)
        }
        return cell
    }
    
    // MARK: - UITableViewController Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if let msg = (fetchedResultsController?.objectAtIndexPath(indexPath) as? TestResult)?.detailMessage() {
            let alertController = UIAlertController(title: "Test Result Details", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (alertAction: UIAlertAction) in
                dispatch_async(GlobalMainQueue, {
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                })
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            if let testResult = fetchedResultsController?.objectAtIndexPath(indexPath) as? TestResult {
                TestResult.deleteTestResult(testResult, viewController: self)
            }
        }
    }
    
    // MARK: - Custom Methods
    func editTableView(sender: AnyObject?) {
        // Update Table View
        tableView.setEditing(!tableView.editing, animated: true)
        
        // Update Edit Button
        if (tableView.editing) {
            navigationItem.rightBarButtonItem?.title = NSLocalizedString("Done", comment: "")
        } else {
            navigationItem.rightBarButtonItem?.title = NSLocalizedString("Edit", comment: "")
        }
    }
}

extension TestResultListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
}