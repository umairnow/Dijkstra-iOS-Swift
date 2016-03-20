//
//  ITPathPoint.swift
//  InterviewTest
//
//  Created by Umair Aamir on 3/17/16.
//  Copyright © 2016 MyWorkout AS. All rights reserved.
//

import UIKit

class ITPathPoint: NSObject {
    
    var connectionList: [ITPathConnection] = []

    var label: String
    var cost: Int
    var tag: ITCoordinate
    
    override var description: String {
        return "ITPathPoint: \nLabel: \(label) \n Cost: \(cost) \n Connections: \(connectionList.count) \n Tag: \(tag)"
    }
    
    init(label: String, tag: ITCoordinate) {
        self.label = label
        self.tag = tag
        self.cost = Int(self.label.asciiValue)
    }
    
    func addConnection(connection: ITPathConnection) -> Void {
        self.connectionList.append(connection)
    }
    
    func getConnectionToPointWithTag(tag: ITCoordinate) -> ITPathConnection? {
        if let found = self.connectionList.indexOf({$0.point.tag == tag}) {
            return self.connectionList[found]
        }
        return nil
    }
}

class ITPathConnection: NSObject {
    var point: ITPathPoint
    var weight: Int

    private var sourceCost: Int
    
    override var description: String {
        return "ITPathConnection: \nWeight: \(weight) \nPoint: \(point)"
    }
    
    init(sourceCost: Int, point: ITPathPoint) {
        self.point = point
        self.sourceCost = sourceCost
        self.weight = sourceCost - self.point.cost
        if self.weight < 0 {
            self.weight = self.weight * -1
        }
    }
}

public class ITCoordinate: NSObject {
    public var row: Int
    public var column: Int
    public var itemIndex: Int
    
    override public var description: String {
        return "ITCoordinate: \nRow: \(row) \n Column: \(column) \n Index: \(itemIndex)"
    }
    
    init(row: Int, column: Int, itemIndex: Int) {
        self.row = row
        self.column = column
        self.itemIndex = itemIndex
    }
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
        self.itemIndex = -1
    }
    
    public func indexByCoordinates(totalColumns: Int) -> Int {
        self.itemIndex = self.row * totalColumns + column
        return self.itemIndex
    }
}

public func ==(lhs: ITCoordinate, rhs: ITCoordinate) -> Bool {
    return (lhs.row == rhs.row && lhs.column == rhs.column)
}