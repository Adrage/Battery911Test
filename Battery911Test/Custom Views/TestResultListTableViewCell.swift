//
//  TestResultListTableViewCell.swift
//  Battery911Test
//
//  Created by Adrian C. Johnson on 10/27/16.
//  Copyright © 2016 CrossVIsion Development Studios. All rights reserved.
//

import Foundation

class TestResultListTableViewCell: UITableViewCell {
    static let cellId = "TestResultListTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.applyTheme()
    }
    
    //MARK: - Class Variables
    class func cellIdentifier() -> String {
        return cellId
    }
    
    class func cellName() -> String {
        return cellId
    }
    
    class func cellHeight() -> CGFloat {
        return 44.0
    }
}

extension TestResultListTableViewCell {
    func configureForTestResult(testResult: TestResult) {
        nameLabel.text = testResult.patientName
        scoreLabel.text = testResult.score()
        print(testResult.score())
    }
}

private extension TestResultListTableViewCell {
    func applyTheme() {
        
    }
}