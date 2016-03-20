//
//  ITUtility.swift
//  InterviewTest
//
//  Created by Umair Aamir on 2/4/16.
//  Copyright © 2016 MyWorkout AS. All rights reserved.
//

import UIKit

let utility: ITUtility = ITUtility.sharedInstance

class ITUtility: NSObject {
    
    static let sharedInstance: ITUtility = ITUtility()
    
    // Constants
    let messageOperationDelay: String = "Current on going operation will take a little longer because of too many iterations. Path finding is a really heavier operation than finding shortest path. You can reduce the words in your sentence to make the search quick. Normally upto 15 words, it doesn't take much time."
    
    let titleOperationDelay: String = "Performing Operation"
    
    
    lazy var SCREEN_WIDTH: CGFloat = {
        [unowned self] in
        return CGRectGetWidth(UIScreen.mainScreen().bounds)
        }()
    
    lazy var SCREEN_HEIGHT: CGFloat = {
        [unowned self] in
        return CGRectGetHeight(UIScreen.mainScreen().bounds)
        }()
    
    // MARK: Alert Messages
    
    internal func showCancelTypeAlert(title title: String!, message: String!, buttonTitle bTitle: String!) -> UIAlertController {
        return self.showAlert(title: title, message: message, buttonsDictionary: ["": {($0)}, bTitle: {(alertAction: UIAlertAction!) -> Void in}])
    }
    
    // MARK: Helping Methods
    
    /**
    * shows alert to any controller with
    * title, message and a dictionary for button with value of closures and with button titles in key
    * Cancel button should be on second index
    * 1st Index is for default button
    * from third to onward are destructive buttons with red colours
    * to skip any index use this key/value:  "": {($0)}
    */
    internal func showAlert(title title: String?,
        message: String?,
        buttonsDictionary buttons: Dictionary<String, (UIAlertAction!) -> Void>!) -> UIAlertController {
            
            let alertController: UIAlertController = UIAlertController(title: title,
                message: message,
                preferredStyle: UIAlertControllerStyle.Alert)
            
            var count: Int = 0
            for (bTitle, bAction) in buttons {
                if bTitle != "" {
                    var style: UIAlertActionStyle = UIAlertActionStyle.Destructive
                    if count > 1 {
                        style = UIAlertActionStyle.Destructive
                    } else if count == 1 {
                        style = UIAlertActionStyle.Default
                    } else {
                        style = UIAlertActionStyle.Cancel
                    }
                    
                    let alertAction: UIAlertAction = UIAlertAction(title: bTitle, style: style, handler: bAction)
                    alertController.addAction(alertAction)
                }
                count++
            }
            let rootController = UIApplication.sharedApplication().keyWindow?.rootViewController
            rootController!.presentViewController(alertController, animated: true, completion: nil)
            return alertController
    }
    
    internal func posibleRows(count: Int, columns: Int) -> Int {
        var totalRows = count/columns
        let floatRows = Float(count)/Float(columns)
        if floatRows > Float(totalRows) {
            totalRows = totalRows + 1
        }
        return totalRows
    }
    
    internal func getConnectionIndicesForTag(tag: ITCoordinate, totalColumns: Int, totalRows: Int) -> [ITCoordinate] {
        
        let gridIndices = [ITCoordinate(row: tag.row, column: tag.column - 1), ITCoordinate(row: tag.row, column: tag.column + 1), ITCoordinate(row: tag.row - 1, column: tag.column), ITCoordinate(row: tag.row - 1, column: tag.column - 1), ITCoordinate(row: tag.row - 1, column: tag.column + 1), ITCoordinate(row: tag.row + 1, column: tag.column), ITCoordinate(row: tag.row + 1, column: tag.column - 1), ITCoordinate(row: tag.row + 1, column: tag.column + 1)]
        return gridIndices
    }
}
