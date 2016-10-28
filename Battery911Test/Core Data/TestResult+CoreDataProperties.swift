//
//  TestResult+CoreDataProperties.swift
//  Battery911Test
//
//  Created by Adrian C. Johnson on 10/27/16.
//  Copyright © 2016 CrossVIsion Development Studios. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TestResult {

    @NSManaged var age: NSNumber?
    @NSManaged var gender: String?
    @NSManaged var hasMigraines: NSNumber?
    @NSManaged var patientName: String?
    @NSManaged var timeStamp: NSDate?
    @NSManaged var usedHallucinogenicDrugs: NSNumber?

}
