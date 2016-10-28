//
//  TestResults.swift
//  Battery911Test
//
//  Created by Adrian C. Johnson on 10/27/16.
//  Copyright © 2016 CrossVIsion Development Studios. All rights reserved.
//

import Foundation
import CoreData

@objc(TestResult)
class TestResult: NSManagedObject {
    
    func dictionaryRepresentation() -> [String : AnyObject] {
        var properties = [String : AnyObject]()
        if let _patientName = self.patientName {
            properties["patientName"] = _patientName
        }
        if let _hasMigraines = self.hasMigraines {
            properties["haveMigraines"] = _hasMigraines
        }
        if let _age = self.age {
            properties["age"] = _age
        }
        if let _gender = self.gender {
            properties["gender"] = _gender
        }
        if let _usedHallucinogenicDrugs = self.usedHallucinogenicDrugs {
            properties["usedHallucinogenicDrugs"] = _usedHallucinogenicDrugs
        }
        if let _timeStamp = self.timeStamp {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZ"
            properties["timeStamp"] = dateFormatter.stringFromDate(_timeStamp)
        }
        return properties
    }
    
    func detailMessage() -> String {
        let _patientName = self.patientName != nil ? self.patientName! : "N/A"
        let _age = self.age != nil ? "\(self.age!)" : "N/A"
        let _gender = self.gender != nil ? self.gender!.capitalizedString : "N/A"
        let _hasMigraines = self.hasMigraines != nil ? "\(self.hasMigraines!.boolValue)" : "N/A"
        let _usedHallucinogenicDrugs = self.usedHallucinogenicDrugs != nil ? "\(self.usedHallucinogenicDrugs!.boolValue)" : "N/A"
        
        var msg = "Patient Name: \(_patientName)\n"
        msg += "Age: \(_age)\n"
        msg += "Gender: \(_gender)\n"
        msg += "Has Migraines: \(_hasMigraines)\n"
        msg += "Used Hallucinogenic Drugs: \(_usedHallucinogenicDrugs)\n\n"
        msg += "Score: \(self.score())"
        return msg
    }
    
    func score() -> String {
        var total: Int = 0
        if let _hasMigraines = self.hasMigraines {
            total += _hasMigraines.boolValue ? 25 : 0
        }
        if let _age = self.age {
            total += _age.integerValue <= 15 ? 25 : 0
        }
        if let _gender = self.gender {
            total += _gender == "Male" ? 25 : 0
        }
        if let _usedHallucinogenicDrugs = self.usedHallucinogenicDrugs {
            total += _usedHallucinogenicDrugs.boolValue ? 25 : 0
        }
        return "\(total)%"
    }
    
    class func createTestResultWithPatientName(patientName: String, hasMigraines: Bool, age: Int, gender: String, usedHallucinogenicDrugs: Bool, completion: (() -> Void)?, failure failureBlock: ((error: NSError) -> Void)?) {
        MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext) in
            let testResult = TestResult.MR_createEntityInContext(localContext)
            testResult?.patientName = patientName
            testResult?.hasMigraines = hasMigraines
            testResult?.age = age
            testResult?.gender = gender
            testResult?.usedHallucinogenicDrugs = usedHallucinogenicDrugs
            testResult?.timeStamp = NSDate()
        }) { (MR_success: Bool, MR_error: NSError?) in
            if let error = MR_error {
                failureBlock?(error: error)
            } else {
                completion?()
            }
        }
    }
    
    class func deleteTestResult(testResult: TestResult, viewController: UIViewController?) {
        MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext) in
            testResult.MR_deleteEntityInContext(localContext)
        }, completion: { (MR_Success: Bool, MR_Error: NSError?) in
            if let _viewController = viewController {
                dispatch_async(GlobalMainQueue, {
                    let alertController = UIAlertController(title: "Record Deleted", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alertAction: UIAlertAction) in
                        alertController.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    _viewController.presentViewController(alertController, animated: true, completion: nil)
                })
            }
        })
    }
}
