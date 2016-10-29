//
//  TestResultEntryTableViewController.swift
//  Battery911Test
//
//  Created by Adrian C. Johnson on 10/27/16.
//  Copyright © 2016 CrossVIsion Development Studios. All rights reserved.
//

import Foundation

class TestResultEntryTableViewController: UITableViewController {
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var hasMigrainesSwitch: UISwitch!
    @IBOutlet weak var drugsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Todd’s Syndrome"
        applyTheme()
    }
}

extension TestResultEntryTableViewController {
    // MARK: - Actions
    @IBAction func submitTestResultsClicked(sender: UIButton) {
        let alertController = UIAlertController(title: "Test Result", message: "Do you want to add test result?", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alertAction: UIAlertAction) in
            self.addTestResult()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alertAction: UIAlertAction) in
            dispatch_async(GlobalMainQueue, {
                alertController.dismissViewControllerAnimated(true, completion: nil)
            })
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}


// MARK: - Private Methods
private extension TestResultEntryTableViewController {
    func applyTheme() {
        hasMigrainesSwitch.tintColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        hasMigrainesSwitch.onTintColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        drugsSwitch.tintColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        drugsSwitch.onTintColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
    }
    
    func addTestResult() {
        guard fullNameTextField.text != nil && fullNameTextField.text!.characters.count > 5 else { return }
        guard ageTextField.text != nil && Int(ageTextField.text!) > 0 else { return }
        
        let gender = self.genderSegmentedControl.selectedSegmentIndex == 0 ? "Male" : "Female"
        
        TestResult.createTestResultWithPatientName(fullNameTextField.text!, hasMigraines: hasMigrainesSwitch.on, age: Int(ageTextField.text!)!, gender: gender, usedHallucinogenicDrugs: self.drugsSwitch.on, completion: {
            dispatch_async(GlobalMainQueue, {
                let alertController = UIAlertController(title: "Record Added", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alertAction: UIAlertAction) in
                    self.resetForm()
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
            })
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func resetForm() {
        fullNameTextField.text = nil
        ageTextField.text = nil
        genderSegmentedControl.selectedSegmentIndex = 0
        hasMigrainesSwitch.setOn(false, animated: true)
        drugsSwitch.setOn(false, animated: true)
    }
}